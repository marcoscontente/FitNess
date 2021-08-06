import Foundation

class AppModel {

  static let instance = AppModel()
  let dataModel = DataModel()
	var stateChangedCallback: ((AppModel) -> ())?
	private(set) var appState: AppState = .notStarted {
		didSet {
			stateChangedCallback?(self)
		}
	}

  func start() throws {
    guard dataModel.goal != nil else {
      throw AppError.goalNotSet
    }
    appState = .inProgress
  }
	
	func restart() {
		appState = .notStarted
		dataModel.restart()
	}
	
	func pause() {
		appState = .paused
	}
	
	func setCompleted() throws {
		guard dataModel.goal != nil else {
			throw AppError.invalidState
		}
		appState = .completed
	}
	
	func setCaught() throws {
		guard dataModel.goal != nil else {
			throw AppError.invalidState
		}
		appState = .caught
	}
	
	
}
