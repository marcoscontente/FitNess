//
//  StepCountControllerTests.swift
//  FitNessTests
//
//  Created by Marcos Contente on 27/07/21.
//  Copyright © 2021 Razeware. All rights reserved.
//

import XCTest
@testable import FitNess

class StepCountControllerTests: XCTestCase {

	var sut: StepCountController!
	
	override func setUp() {
		super.setUp()
		sut = StepCountController()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
  
  func testController_whenStartTapped_appIsInProgress() {
//    when
    startStopPause()

//    then
    let state = AppModel.instance.appState
    XCTAssertEqual(state, AppState.inProgress)
  }

  func testController_whenStartTapped_buttonLabelIsPause() {
    //    when
    startStopPause()
    
//    then
    let text = sut.startButton.title(for: .normal)
    XCTAssertEqual(text, AppState.inProgress.nextStateButtonLabel)
  }
  
//  MARK: - Initial State
  
  func testController_whenCreated_buttonLabelIsStart() {
//    given
    sut.viewDidLoad()
    
//    then
    let text = sut.startButton.title(for: .normal)
    XCTAssertEqual(text, AppState.notStarted.nextStateButtonLabel)
  }
  
  
//  MARK: - When Helpers
  fileprivate func startStopPause() {
    sut.startStopPause(nil)
  }
  
}
