@testable import FitNess

extension AppModel {
	func setToComplete() {
		dataModel.setToComplete()
		try! setCompleted()
	}
	
	func setToCaught() {
		dataModel.setToCaught()
		try! setCaught()
	}
}
