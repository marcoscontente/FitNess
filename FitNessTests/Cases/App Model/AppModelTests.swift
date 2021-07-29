import XCTest
@testable import FitNess

class AppModelTests: XCTestCase {
	
//  MARK: - Properties
  
	var sut: AppModel!
	
//  MARK: - XCTest LifeCycle
  
	override func setUp() {
		super.setUp()
		sut = AppModel()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
  
//  MARK: - Given:

  fileprivate func givenGoalSet() {
    sut.dataModel.goal = 1000
  }
		
	fileprivate func givenInProgress() {
		givenGoalSet()
		try? sut.start()
	}
	
	func givenCompleteReady() {
		sut.dataModel.setToComplete()
	}
	
	func givenCaughtReady() {
		sut.dataModel.setToCaught()
	}
	
//	 MARK: - Lifecycle:

	func testAppModel_whenInitialized_isInNotStartedState() {
//		when
			let initialState = sut.appState
		
//		then
			XCTAssertEqual(initialState, AppState.notStarted)
	}
	
//	  MARK: - Start:

	func testAppModel_whenStarted_isInInProgressState() {
//    given
      givenGoalSet()
    
//		when - started
      try? sut.start()
		
//		then - it is in inProgress
			let observedState = sut.appState
			XCTAssertEqual(observedState, AppState.inProgress)
	}
	
  func testModelWithNoGoal_whenStarted_thorwsError() {
    XCTAssertThrowsError(try sut.start())
  }
	
  func testStart_withGoalSet_doesNotThrow() {
//    given
    givenGoalSet()
    
//    then
    XCTAssertNoThrow(try sut.start())
  }
	
//	MARK: - Restart:
	
	func testAppModel_whenReset_isInNotStartedState() {
//		given
		givenInProgress()
		
//		when
		sut.restart()
		
//		then
		XCTAssertEqual(sut.appState, .notStarted)
	}
	
	func testAppModel_whenReset_goalIsNil() {
//				 given
		givenInProgress()

//		when
		sut.restart()
		
//		then
		XCTAssertNil(sut.dataModel.goal)
	}
	
//	MARK: - Pause:
	
	func testAppModel_whenPaused_isInPausedState() {
//		given
		givenInProgress()
		
//		when
		sut.pause()
		
//		then
		XCTAssertEqual(sut.appState, .paused)
	}
	
	// MARK: - Terminal States
	
	func testModel_whenCompleted_isInCompletedState() {
//		given
		givenCompleteReady()
		
//		when
		try? sut.setCompleted()
		
//		then
		XCTAssertTrue(sut.dataModel.goalReached)
	}
	
	func testModelNotCompleteReady_whenCompleted_throwsError() {
		XCTAssertThrowsError(try sut.setCompleted())
	}
	
	func testModelCompleteReady_whenCompleted_doesNotThrow() {
//		    given
		givenCompleteReady()
		
//		    then
		XCTAssertNoThrow(try sut.setCompleted())
	}
	
	func testModel_whenCaught_isInCaughtState() {
//		given
		givenCaughtReady()
		
//		when
		try? sut.setCaught()
		
//		then
		XCTAssertTrue(sut.dataModel.caught)
	}
	
	func testModelNotCaughtReady_whenCaught_throwsError() {
		XCTAssertThrowsError(try sut.setCaught())
	}
	
	func testModelCaughtReady_whenCaught_doesNotThrow() {
//		given
		givenCaughtReady()
		
//		then
		XCTAssertNoThrow(try sut.setCaught())
	}
}
