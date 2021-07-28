import XCTest
@testable import FitNess

class AppModelTests: XCTestCase {
	
	var sut: AppModel!
	
	override func setUp() {
		super.setUp()
		sut = AppModel()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func testAppModel_whenInitialized_isInNotStartedState() {
//		when
			let initialState = sut.appState
		
//		then
			XCTAssertEqual(initialState, AppState.notStarted)
	}
	
	func testAppModel_whenStarted_isInInProgressState() {
//		when - started
			sut.start()
		
//		then - it is in inProgress
			let observedState = sut.appState
			XCTAssertEqual(observedState, AppState.inProgress)
	}
	
	
	
}
