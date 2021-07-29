import XCTest
@testable import FitNess

class StepCountControllerTests: XCTestCase {

	var sut: StepCountController!
	
  // MARK: - Test Lifecycle

	override func setUp() {
		super.setUp()
		let rooController = loadRootViewController()
		sut = rooController.stepController
	}
	
	override func tearDown() {
		AppModel.instance.restart()
		sut.updateUI()
		super.tearDown()
	}
	
	//	MARK: - Given Helpers:
	
	fileprivate func givenInProgress() {
		givenGoalSet()
		sut.startStopPause(nil)
	}
	
	fileprivate func givenGoalSet() {
		AppModel.instance.dataModel.goal = 1000
	}
	
	//  MARK: - When Helpers:
	
	fileprivate func whenStartStopPauseCalled() {
		sut.startStopPause(nil)
	}
	
	//  MARK: - Initial State:
	
	func testController_whenCreated_buttonLabelIsStart() {
		let text = sut.startButton.title(for: .normal)
		XCTAssertEqual(text, AppState.notStarted.nextStateButtonLabel)
	}
  
  // MARK: - In Progress:

  func testController_whenStartTapped_appIsInProgress() {
//		given
		givenGoalSet()
		
//    when
    whenStartStopPauseCalled()

//    then
    let state = AppModel.instance.appState
    XCTAssertEqual(state, AppState.inProgress)
  }

  func testController_whenStartTapped_buttonLabelIsPause() {
//		given
		givenGoalSet()
		
//    when
    whenStartStopPauseCalled()
    
//    then
    let text = sut.startButton.title(for: .normal)
    XCTAssertEqual(text, AppState.inProgress.nextStateButtonLabel)
  }
  
//  MARK: - Goal:
	
	func testDataModel_whenGoalUpdate_updatesToNewGoal() {
//		when
		sut.updateGoal(newGoal: 50)
		
//		then
		XCTAssertEqual(AppModel.instance.dataModel.goal, 50)
	}
	
//	MARK: - Chase View:
	
	func testChaseView_whenLoaded_isNotStarted() {
//		when
		whenStartStopPauseCalled()
		
//		then
		let chaseView = sut.chaseView
		XCTAssertEqual(chaseView?.state, AppState.notStarted)
	}

	func testChaseView_whenInProgress_viewIsInProgress() {
//		given
		givenInProgress()
		
//		then
		let chaseView = sut.chaseView
		XCTAssertEqual(chaseView?.state, AppState.inProgress)
	}
}
