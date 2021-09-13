//
//  Game.swift
//  pong
//
//  Created by Charles Faquin on 8/14/21.
//

import Foundation

struct Game {
	let firstService: TeamID
	let secondService: TeamID
	let tableSides: TableSides
	let startDate = Date()
	var home: Int = 0
	var guest: Int = 0
	var gameType: GameType
	var service: TeamID
	var status: Status = .normal
	var nextDeuceService: TeamID?
	var endDate: Date?
	
	init(_ gameType: GameType, firstService: TeamID, tableSides: TableSides) {
		self.gameType = gameType
		self.firstService = firstService
		service = firstService
		self.tableSides = tableSides
		switch firstService {
		case .guest:
			secondService = .home
		case .home:
			secondService = .guest
		}
	}
	
	mutating func setScoreManually(home: Int, guest: Int) {
		self.home = max(0, home)
		self.guest = max(0, guest)
		updateStatus()
		updateService()
	}
		
	mutating func addPoint(_ team: TeamID) {
		switch team {
		case .home:
			home += 1
		case .guest:
			guest += 1
		}
		updateStatus()
		updateService()
	}
	
	mutating func removePoint(_ team: TeamID) {
		switch team {
		case .home:
			home = max(home - 1, 0)
		case .guest:
			guest = max(guest - 1, 0)
		}
		updateStatus()
		updateService()
	}
}

// Computed and Helpers
extension Game {
	var pointGoalReached: Bool {
		home >= gameType.pointGoal || guest >= gameType.pointGoal
	}
	
	var winner: TeamID? {
		guard let ad = advantage, let disScore = disadvantage?.score else { return nil }
		if skunk || (pointGoalReached && (ad.score - disScore > 1)) {
			return ad.team
		}
		return nil 
	}
	
	var disadvantage: (team: TeamID, score: Int)? {
		if home > guest {
			return (.guest, guest)
		} else if guest > home {
			return (.home, home)
		}
		return nil
	}
	
	var advantage: (team: TeamID, score: Int)? {
		if home > guest {
			return (.home, home)
		} else if guest > home {
			return (.guest, guest)
		}
		return nil
	}
	
	var skunk: Bool {
		guard let adScore = advantage?.score, let loserScore = disadvantage?.score else { return false }
		return (adScore == 7 && loserScore == 0) || (adScore == 11 && loserScore == 1)
	}

	private mutating func updateService() {
		switch status {
		case .normal:
			if (home + guest) % 10 < 5, service != firstService {
				service = firstService
			} else if (home + guest) % 10 > 4, service != secondService {
				service = secondService
			}
		case .gamePoint:
			guard let disadvantage = disadvantage else { return }
			service = disadvantage.team
		case .adOut:
			guard let disadvantage = disadvantage else { return }
			service = disadvantage.team
		case .deuce:
			if firstService == service {
				service = secondService
				nextDeuceService = firstService
			} else {
				service = firstService
				nextDeuceService = secondService
			}
		case .deuceOT:
			if let nextDeuceService = nextDeuceService, nextDeuceService != service {
				service = nextDeuceService
			}
			switch service {
			case .home:
				nextDeuceService = .guest
			case .guest:
				nextDeuceService = .home
			}
			
		default:
			break
		}
	}
	
	private mutating func switchService() {
		if service == firstService {
			service = secondService
		} else {
			service = firstService
		}
	}
	
	private mutating func updateStatus() {
		guard
			let advantage = advantage,
			let disadvantage = disadvantage
		else {
			/// MARK: Handle tied score
			switch pointGoalReached {
			case true:
				status = .deuceOT
			case false:
				let deuceTotal = (gameType.pointGoal - 1) * 2
				if home + guest == deuceTotal {
					status = .deuce
				} else {
					status = .normal
				}
			}
			return
		}
		/// MARK: Handle untied score
		if skunk {
			status = .skunk
			return
		}
		if pointGoalReached && (advantage.score - disadvantage.score > 1) {
			status = .gameOver
			return
		}
		switch advantage.score {
		case 0..<gameType.pointGoal - 1:
			status = .normal
		case gameType.pointGoal - 1:
			status = .gamePoint
		default:
			status = .adOut
		}
	}
}

extension Game {
	enum Status: Int, CaseIterable {
		case normal
		case gamePoint
		case deuce
		case deuceOT
		case adOut
		case gameOver
		case skunk
		
		var statusVM: StatusVM? {
			switch self {
			case .deuce:
				return StatusVM(text: "D E U C E!", temporary: true)
			case .adOut:
				return StatusVM(text: "A D - O U T", temporary: true)
			case .gamePoint:
				return StatusVM(text: "Game Point!", temporary: true)
			case .skunk:
				return StatusVM(text: "🦨 Skunked!? You stink! 🦨", temporary: false)
			default:
				return nil
			}
		}
	}
}
