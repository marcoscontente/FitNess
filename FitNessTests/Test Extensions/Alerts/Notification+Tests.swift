import Foundation
@testable import FitNess

extension Notification {
	var alert: Alert? { userInfo?[AlertNotification.Keys.alert] as? Alert }
}
