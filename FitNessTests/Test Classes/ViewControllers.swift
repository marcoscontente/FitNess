import UIKit
@testable import FitNess

func loadRootViewController() -> RootViewController {
	guard let rootViewController = UIApplication.shared.windows.first?.rootViewController as? RootViewController else {
		return RootViewController()
	}
	return rootViewController
}
