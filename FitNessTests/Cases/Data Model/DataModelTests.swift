import XCTest
@testable import FitNess

class DataModelTests: XCTestCase {
  
//  MARK: - Properties
  var sut: DataModel!
  
//  MARK: - XCTest LifeCycle
  override func setUp() {
    super.setUp()
    sut = DataModel()
  }
  
  override func tearDown() {
		AlertCenter.instance.clearAlerts()
    sut = nil
    super.tearDown()
  }
	
//	MARK: - Given:
	
	func givenSomeProgress() {
		sut.goal = 1000
		sut.distance = 100
		sut.nessie.distance = 50
		sut.steps = 10
	}
	
	func givenExpectationForNotification(alert: Alert) -> XCTestExpectation {
		let exp = XCTNSNotificationExpectation(name: AlertNotification.name,
																					 object: AlertCenter.instance,
																					 notificationCenter: AlertCenter.instance.notificationCenter)
		exp.handler = { notification -> Bool in
			notification.alert == alert
		}
		exp.expectedFulfillmentCount = 1
		exp.assertForOverFulfill = true
		return exp
	}
	
//	MARK: - LifeCycle:
	
	func testModel_whenRestarted_goalIsUnset() {
//		given
		givenSomeProgress()
		
//		when
		sut.restart()
		
//		then
		XCTAssertNil(sut.goal)
	}
	
	func testModel_whenRestarted_stepsAreCleared() {
//		given
		givenSomeProgress()
		
//		when
		sut.restart()
		
//		then
		XCTAssertEqual(sut.steps, 0)
	}
	
	func testModel_whenRestarted_distanceIsCleared() {
//		given
		givenSomeProgress()
		
//		when
		sut.restart()
		
//		then
		XCTAssertEqual(sut.distance, 0)
	}
	
	func testModel_whenRestarted_nessieIsReset() {
//		given
		givenSomeProgress()
		
//		when
		sut.restart()
		
//		then
		XCTAssertEqual(sut.nessie.distance, 0)
	}
  
//  MARK: - Goal Tests:
  
  func testModel_whenStarted_goalIsNotReached() {
    XCTAssertFalse(sut.goalReached,
									 "goalReached should be false when the model is created")
  }
  
  func testModel_whenStepsReachGoal_goalIsReached() {
//    given
    sut.goal = 1000
    
//    when
    sut.steps = 1000
    
//    then
    XCTAssertTrue(sut.goalReached)
  }
	
	func testGoal_whenUserCaught_cannotBeReached() {
//		given goal should be reached
		sut.goal = 1000
		sut.steps = 1000
		
//		when caught by Nessie
		sut.distance = 100
		sut.nessie.distance = 100
		
//		then
		XCTAssertFalse(sut.goalReached)
	}
  
//	MARK: - Nessie Tests:
	
	func testModel_whenStarted_userIsNotCaught() {
		XCTAssertFalse(sut.caught)
	}
	
	func testModel_whenUserAheadOfNessie_isNotCaught() {
//		given
		sut.distance = 1000
		sut.nessie.distance = 100
		
//		then
		XCTAssertFalse(sut.caught)
	}
	
	func testModel_whenNessieAheadOfUser_isCaught() {
//		given
		sut.distance = 100
		sut.nessie.distance = 1000
		
//		then
		XCTAssertTrue(sut.caught)
	}
	
//	MARK: - Alerts:
	
	func testWhenStepsHit25Percent_milestoneNotificationGenerated() {
//		given
		sut.goal = 400
		let exp = givenExpectationForNotification(alert: .milestone25Percent)
		
//		when
		sut.steps = 100
		
//		then
		wait(for: [exp], timeout: 5)
	}
	
	func testWhenStepsHit50Percent_milestoneNotificationGenerated() {
		//		given
		sut.goal = 400
		let exp = givenExpectationForNotification(alert: .milestone50Percent)
		
		//		when
		sut.steps = 200
		
		//		then
		wait(for: [exp], timeout: 5)
	}
	
	func testWhenStepsHit75Percent_milestoneNotificationGenerated() {
		//		given
		sut.goal = 400
		let exp = givenExpectationForNotification(alert: .milestone75Percent)

		//		when
		sut.steps = 300
		
		//		then
		wait(for: [exp], timeout: 5)
	}
	
	func testWhenStepsHit100Percent_milestoneNotificationGenerated() {
		//		given
		sut.goal = 400
		let exp = givenExpectationForNotification(alert: .goalComplete)

		
		//		when
		sut.steps = 400
		
		//		then
		wait(for: [exp], timeout: 5)
	}
	
	func testWhenGoalReached_allMilestonesNotificationsSent() {
//		given
		sut.goal = 400
		let expectations = [
			givenExpectationForNotification(alert: .milestone25Percent),
			givenExpectationForNotification(alert: .milestone50Percent),
			givenExpectationForNotification(alert: .milestone75Percent),
			givenExpectationForNotification(alert: .goalComplete)
		]
		
//		when
		sut.steps = 400
		
//		then
		wait(for: expectations, timeout: 1, enforceOrder: true)
	}
	
	func testWhenStepsIncreased_onlyOneMilestoneNotificationSent() {
//		given
		sut.goal = 10
		let expectations = [
			givenExpectationForNotification(alert: .milestone25Percent),
			givenExpectationForNotification(alert: .milestone50Percent),
			givenExpectationForNotification(alert: .milestone75Percent),
			givenExpectationForNotification(alert: .goalComplete)
		]
		
//		clear out the alerts to simulate user interaction
		let alertObserver = AlertCenter.instance
																		.notificationCenter
																		.addObserver(forName: AlertNotification.name,
																								 object: nil,
																								 queue: .main) { notification in
																			if let alert = notification.alert {
																				AlertCenter.instance.clear(alert: alert)
																			}
		}
		
//		when
		for step in 1...10 {
			self.sut.steps = step
			sleep(1)
		}
		
//		then
		wait(for: expectations, timeout: 20, enforceOrder: true)
		AlertCenter.instance.notificationCenter.removeObserver(alertObserver)
	}
}
