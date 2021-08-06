import UIKit
@testable import FitNess

extension RootViewController {
	var stepController: StepCountController {
		guard let children = children.first(where: { $0 is StepCountController })
						as? StepCountController else {
			return StepCountController()
		}
		return children
	}
	
	var alertController: AlertViewController {
		guard let children = children.first(where: {$0 is AlertViewController}) as? AlertViewController else {
			return AlertViewController()
		}
		return children
	}
}
