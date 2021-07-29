import Foundation

class DataModel {

//	MARK: - Goal:
	
  var goal: Int?
  var steps: Int = 0
	
  var goalReached: Bool {
    if let goal = goal,
       steps >= goal,
			 !caught {
      return true
    }
    return false
  }

//	MARK: - Nessie:
	
	let nessie = Nessie()
	var distance: Double = 0
	
	var caught: Bool {
		distance > 0 && nessie.distance >= distance
	}
	
//	MARK: - LifeCycle
	func restart() {
		goal = nil
		steps = 0
		distance = 0
		nessie.distance = 0
	}
}
