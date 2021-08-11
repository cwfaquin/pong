//
//  Score.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

final class Match: ObservableObject {
	
	@Published var matchStatus: MatchStatus = .pregame
	@Published var service: TeamID = .guest
	@Published var home: Team = Team(.home)
	@Published var guest: Team = Team(.guest)
	@Published var gameScore: Score = Score(pointGoal: GameType.long.pointGoal)
	@Published var setScore: Score = Score(pointGoal: SetType.bestOfThree.pointGoal)
	@Published var matchScore: Score = Score(pointGoal: MatchType.bestOfSeven.pointGoal)
	@Published var tableSides: TableSides = TableSides()
	
	// End of game switch sides, End of set Ping
	
	func incrementGameScore(_ increment: Int, team: TeamID) {
		switch team {
		case .home:
			gameScore.home = max(gameScore.home + increment, 0)
		case .guest:
			gameScore.guest = max(gameScore.guest + increment, 0)
		}
		guard !gameScore.skunk else {
			print("SKUNKED")
			print("GAME COMPLETE")
			matchStatus = .gameComplete
			return
		}
		if gameScore.pointGoalReached, let disadvantage = gameScore.disadvantage, let advantage = gameScore.advantage {
			if advantage.score - disadvantage.score > 1 {
				print("GAME COMPLETE")
				matchStatus = .gameComplete
				return
			}
		}
		guard !gameScore.deuce else {
			print("DEUCE")
			if gameScore.pointGoalReached {
				print("DON'T SWITCH")
			} else {
				print("SWITCHjones")
				serviceChange()
			}
			return
		}
		guard !gameScore.gamePoint else {
			if gameScore.adOut {
				print("AD OUT")
			} else {
				print("GAME POINT")
			}
			if gameScore.disadvantage?.team != service {
				print("SERVICE CHANGE")
				serviceChange()
			}
			return
		}
		if gameScore.total % 5 == 0 {
			print("SERVICE CHANGE")
			serviceChange()
		}
	}
	
	func incrementSetScore(_ increment: Int, team: TeamID) {
		switch team {
		case .home:
			setScore.home = min(max(setScore.home + increment, 0), setScore.pointGoal)
		case .guest:
			setScore.guest = min(max(setScore.guest + increment, 0), setScore.pointGoal)
		}
		if setScore.pointGoalReached {
			incrementMatchScore(1, team: team)
		} else {
			matchStatus = .gameComplete //show switch sides
			
		}
		
	}
	
	func incrementMatchScore(_ increment: Int, team: TeamID) {
		switch team {
		case .home:
			matchScore.home = min(max(matchScore.home + increment, 0), matchScore.pointGoal)
		case .guest:
			matchScore.guest = min(max(matchScore.guest + increment, 0), matchScore.pointGoal)
		}
		if matchScore.pointGoalReached {
			matchStatus = .matchComplete
		} else {
			matchStatus = .setComplete
		}
	}
	
	func serviceChange() {
		switch service {
		case .home:
			service = .guest
		case .guest:
			service = .home
		}
	}
	
	func singleTap(_ tableSide: TableSide) {
		switch matchStatus {
		case .pregame:
			tableSides.guestChoice(tableSide)
			matchStatus = .ping
		case .ping:
			service = teamID(tableSide)
			matchStatus = .playing
		case .playing:
			incrementGameScore(1, team: teamID(tableSide))
		default:
			break
		}
	}
	
	func doubleTap(_ tableSide: TableSide) {
		
	}
	
	func longPress(_ tableSide: TableSide) {
		
	}
	
	func applySettings(_ settings: MatchSettings) {
		gameScore.pointGoal = settings.gameType.pointGoal
		setScore.pointGoal = settings.setType.pointGoal
		matchScore.pointGoal = settings.matchType.pointGoal
	}
	
	
	func teamID(_ tableSide: TableSide) -> TeamID {
		tableSides.home == tableSide ? .home : .guest
	}
}

struct Score {
	var home: Int = 0
	var guest: Int = 0
	var pointGoal: Int = 0
	
	mutating func reset() {
		home = 0
		guest = 0
	}
	
	var total: Int {
		home + guest
	}
	
	var pointGoalReached: Bool {
		pointGoal > 0 && (home >= pointGoal || guest >= pointGoal)
	}
	
	var gamePoint: Bool {
		guard let advantage = advantage, disadvantage != nil else { return false }
		if pointGoalReached {
			return true
		} else {
			return advantage.score == pointGoal - 1
		}
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
		(home == 0 && guest == 7) ||
		(home == 7 && guest == 0) ||
		(home == 1 && guest == 11) ||
		(home == 11 && guest == 1)
	}
	
	var deuce: Bool {
		(home >= pointGoal - 1) && (guest >= pointGoal - 1) && guest == home
	}
	
	var adOut: Bool {
		(home > pointGoal) && (guest > pointGoal) && advantage != nil
	}

}


struct TableSides {
	var home: TableSide = .left
	var guest: TableSide = .right
	
	mutating func guestChoice(_ choice: TableSide) {
		guest = choice
		switch choice {
		case .left:
			home = .right
		case .right:
			home = .left
		}
	}
	
	mutating func switchSides() {
		switch home {
		case .left:
			home = .right
			guest = .left
		case .right:
			home = .left
			guest = .right
		}
	}
}
