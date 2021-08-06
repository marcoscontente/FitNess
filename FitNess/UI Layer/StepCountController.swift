import UIKit

extension AppState {
  var nextStateButtonLabel: String {
    switch self {
    case .notStarted:
      return "Start"
    case .inProgress:
      return "Pause"
    case .paused:
      return "Resume"
    case .caught:
      return "Try Again"
    case .completed:
      return "Start Over"
    }
  }
}

class StepCountController: UIViewController {
  @IBOutlet weak var stepCountLabel: UILabel!
  @IBOutlet var startButton: UIButton!
  @IBOutlet weak var chaseView: ChaseView!

  init() {
    super.init(nibName: nil, bundle: nil)
    startButton = UIButton()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
		updateUI()
		AppModel.instance.stateChangedCallback = { model in
			DispatchQueue.main.async {
				self.updateUI()
			}
		}
  }
	
	func updateUI() {
			updateButton()
			updateChaseView()
	}
	
  private func updateButton() {
    let title = AppModel.instance.appState.nextStateButtonLabel
    startButton.setTitle(title, for: .normal)
  }

  // MARK: - UI Actions
  
  @IBAction func startStopPause(_ sender: Any?) {
		switch AppModel.instance.appState {
			case .notStarted:
				start()
			case .inProgress:
				AppModel.instance.pause()
			case .paused:
				start()
			case .completed, .caught:
				AppModel.instance.restart()
		}
		updateUI()
  }
	
	private func start() {
		do {
			try AppModel.instance.start()
		} catch {
			showNeedGoalAlert()
		}
	}
  
  @IBAction func showSettings(_ sender: Any) {
    getGoalFromUser()
  }
}

// MARK: - Goal
extension StepCountController {
	
	func updateGoal(newGoal: Int) {
		AppModel.instance.dataModel.goal = newGoal
	}

  private func showNeedGoalAlert() {
    let alertController = UIAlertController(title: "Set a goal to start",
                                            message: nil,
                                            preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel",
                               style: .cancel)
    let enterGoal = UIAlertAction(title: "Enter Goal",
                                  style: .default) { [weak self] action in
      self?.getGoalFromUser()
    }

    alertController.addAction(cancel)
    alertController.addAction(enterGoal)
    present(alertController, animated: true)
  }

  private func getGoalFromUser() {
    let alertController = UIAlertController(title: "What is your step goal?", message: nil, preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "1000"
      textField.keyboardType = .numberPad
    }
    let action = UIAlertAction(title: "Done", style: .default) { [weak self] action in
      guard let textField = alertController.textFields?.first else { return }
      if let numberString = textField.text,
        let goal = Int(numberString) {
          self?.updateGoal(newGoal: goal)
      } else {
          self?.updateGoal(newGoal: 0)
      }
    }
    alertController.addAction(action)
    present(alertController, animated: true)
  }
}

// MARK: - Chase View
extension StepCountController {
	private func updateChaseView() {
		chaseView.state = AppModel.instance.appState
	}
}
