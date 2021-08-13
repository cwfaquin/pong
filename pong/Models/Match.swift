//
//  Score.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

final class Match: ObservableObject {
	
	@Published var matchStatus: MatchStatus = .guestChooseSide
	@Published var matchType: MatchType = .bestOfFive
	@Published var home: Team = Team(.home)
	@Published var guest: Team = Team(.guest)
	
	@Published var tableSides = TableSides()
	@Published var game: Game = Game(firstService: .guest, tableSides: TableSides())
	@Published var set: Set = Set(firstServe: .guest)
	@Published var homeSets = [Set]()
	@Published var guestSets = [Set]()
	
	/* Single Tap player side buttons used for:
		1. Choose side prematch
		2. Set ping winner preset
		3. Add 1 point in game
	*/
	func singleTap(_ tableSide: TableSide) {
		print("single tap \(String(describing: tableSide))")
		switch matchStatus {
		case .guestChooseSide:
			tableSides = TableSides(guestChoice: tableSide)
			matchStatus = .ping
		case .ping:
			let server = teamID(tableSide)
			set = Set(firstServe: server)
			game = Game(firstService: server, tableSides: tableSides)
			matchStatus = .playing
		case .playing:
			switch game.status {
			case .gameOver:
				print("Nothing game over.")
			default:
				game.addPoint(teamID(tableSide))
			}
		default:
			break
		}
		print(String(describing: matchStatus))
	}
	
	/* Double Tap player side buttons used for:
		1. Remove point in game
	*/
	func doubleTap(_ tableSide: TableSide) {
		let team = teamID(tableSide)
		game.removePoint(team)
	}
	
	func longPress(_ tableSide: TableSide) {
		print("Reset Game")
	}
	
	
	func singleTapMiddle() {
		switch matchStatus {
		case .optionToExtend:
			extendMatch()
			
		case .matchComplete:
			print("POST match results")
			matchStatus = .postgame
			
		case .postgame:
			matchStatus = .pregame
			resetMatch()
			
		case .pregame:
			print("Pregmane")
		
		case .playing:
			switch game.status {
			case .gameOver:
				closeOutGame()
			default:
				print("No action set")
			}
	
		default:
			break
		}
	}
	
	func resetMatch() {
		homeSets = []
		guestSets = []
		tableSides = tableSides.switched()
		set = Set(firstServe: .guest)
		game = Game(firstService: .guest, tableSides: tableSides)
	}
	
	func closeOutGame() {
		guard let winner = game.advantage?.team else {
			assertionFailure("Game over and winner is nil.")
			return
		}
		print("POST game results")
		set.addGame(game, winner: winner)
		if set.setComplete {
			closeOutSet()
		} else {
			let firstService = game.secondService
			tableSides = tableSides.switched()
			game = Game(firstService: firstService, tableSides: tableSides)
		}
	}
	
	func closeOutSet() {
		guard let setWinner = set.winner else {
			assertionFailure("Must be a set winner to get here.")
			return
		}
		print("Set Winner UI")
		switch setWinner {
		case .home:
			homeSets.append(set)
		case .guest:
			guestSets.append(set)
		}
		if matchTotalReached {
			closeOutMatch()
		} else {
			print("Switch sides")
			print("New Set")
			tableSides = tableSides.switched()
			matchStatus = .ping
		}
	}
	
	func closeOutMatch() {
		guard let matchWinner = matchWinner else {
			assertionFailure("No winner of match. Do you still want to close?")
			return
		}
		if matchType.pointGoal < MatchType.bestOfSeven.pointGoal {
			print("give option to extend")
			matchStatus = .optionToExtend
		} else {
			print("Winner \(String(describing: matchWinner))")
			matchStatus = .matchComplete
		}
	}
		
		
	
	func applySettings(_ settings: MatchSettings) {
		game.gameType = settings.gameType
		set.setType = settings.setType
		
	}
		
		func extendMatch() {
			switch matchType {
			case .singleSet:
				matchType = .bestOfThree
			case .bestOfThree:
				matchType = .bestOfFive
			case .bestOfFive:
				matchType = .bestOfSeven
			default:
				assertionFailure("Cannot extend best of 7")
			}
		}
	
	func teamID(_ tableSide: TableSide) -> TeamID {
		tableSides.home == tableSide ? .home : .guest
	}

var matchLoser: (team: TeamID, score: Int)? {
	if homeSets.count > guestSets.count {
		return (.guest, guestSets.count)
	} else if guestSets.count > homeSets.count {
		return (.home, homeSets.count)
	}
	return nil
}

var matchWinner: (team: TeamID, score: Int)? {
	if homeSets.count > guestSets.count {
		return (.home, homeSets.count)
	} else if guestSets.count > homeSets.count {
		return (.guest, guestSets.count)
	}
	return nil
}
	
	var matchTotalReached: Bool {
		homeSets.count == matchType.pointGoal ||
		guestSets.count == matchType.pointGoal
	}
}

struct Game {
	
	enum Status {
		case normal
		case gamePoint
		case deuce
		case deuceOT
		case adOut
		case gameOver
	}
	
	var home: Int = 0
	var guest: Int = 0
	var gameType: GameType = .long
	var service: TeamID
	let firstService: TeamID
	let secondService: TeamID
	let tableSides: TableSides
	let uuid = UUID()
	
	var status: Status = .normal {
		didSet {
			print(String(describing: status))
		}
	}

	var deuceService: TeamID?
	
	init(firstService: TeamID, tableSides: TableSides) {
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
	
	mutating func updateScore(home: Int = 0, guest: Int = 0) {
		self.home = min(max(home, 0), pointGoal)
		self.guest = min(max(guest, 0), pointGoal)
		updateStatus()
		updateService()
	}
	
	mutating func addPoint(_ team: TeamID) {
		switch team {
		case .home:
			updateScore(home: home + 1)
		default:
			updateScore(guest: guest + 1)
		}
	}
	
	mutating func removePoint(_ team: TeamID) {
		switch team {
		case .home:
			updateScore(home: home - 1)
		default:
			updateScore(guest: guest - 1)
		}
	}
	
	private mutating func updateService() {
		switch status {
		case .normal:
			if total % 10 < 5, service != firstService {
				service = firstService
			} else if total % 10 > 4, service != secondService {
				service = secondService
			}
		case .gamePoint, .adOut:
			guard let disadvantage = disadvantage else { return }
			service = disadvantage.team
		case .deuce:
			if let deuceService = deuceService {
				service = deuceService
			} else if service == firstService {
				service = secondService
				deuceService = secondService
			} else {
				service = firstService
				deuceService = secondService
			}
		default:
			break
		}
	}
	
	private mutating func updateStatus() {
		guard !skunk else {
			status = .gameOver
			return
		}
		if pointGoalReached, let disadvantage = disadvantage, let advantage = advantage {
			if advantage.score - disadvantage.score > 1 {
				status = .gameOver
				return
			}
		}
		guard !deuce else {
			status = pointGoalReached ? .deuceOT : .deuce
			return
		}
		guard !gamePoint else {
			status = adOut ? .adOut : .gamePoint
			return
		}
		status = .normal
	}
	
	var pointGoal: Int {
		gameType.pointGoal
	}
	
	var total: Int {
		home + guest
	}
	
	var pointGoalReached: Bool {
		pointGoal > 0 && (home >= pointGoal || guest >= pointGoal)
	}
	
	var tied: Bool {
		home == guest
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
		guard let adScore = advantage?.score, let loserScore = disadvantage?.score else { return false }
		return (adScore == 7 && loserScore == 0) || (adScore == 11 && loserScore == 1)
	}
	
	var deuce: Bool {
		(home >= pointGoal - 1) && (guest >= pointGoal - 1) && guest == home
	}
	
	var adOut: Bool {
		(home > pointGoal) && (guest > pointGoal) && advantage != nil
	}

}

struct Set {
	var home = [Game]()
	var guest = [Game]()
	let firstServe: TeamID
	var setType: SetType = .bestOfThree
	let id = UUID()
	
	
	var setComplete: Bool {
		home.count == setType.pointGoal || guest.count == setType.pointGoal
	}
	
	var winner: TeamID? {
		guard setComplete else { return nil }
		if home.count > guest.count {
			return .home
		} else if guest.count > home.count {
			return .guest
		}
		return nil
	}
	
	mutating func addGame(_ game: Game, winner: TeamID) {
		switch winner {
		case .home:
			home.append(game)
		case .guest:
			guest.append(game)
		}
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
	let home: TableSide
	let guest: TableSide
	
	init(guestChoice: TableSide) {
		guest = guestChoice
		switch guestChoice {
		case .left:
			home = .right
		case .right:
			home = .left
		}
	}
	
	init(home: TableSide = .left, guest: TableSide = .right) {
		self.home = home
		self.guest = guest
	}
	
	func switched() -> TableSides {
		switch home {
		case .left:
			return TableSides(home: .right, guest: .left)
		case .right:
			return TableSides(home: .left, guest: .right)
		}
	}
}
