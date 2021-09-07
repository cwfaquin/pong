//
//  Score.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

final class Match: ObservableObject {
	
	@Published var status: Status = .pregame
	@Published var matchType: MatchType = .singleSet
	@Published var tableSides = TableSides()
	@Published var game: Game = Game(firstService: .guest, tableSides: TableSides())
	@Published var set: GameSet = GameSet(firstServe: .guest)
	@Published var homeSets = [GameSet]()
	@Published var guestSets = [GameSet]()
	

	
	/* Single Tap player side buttons used for:
	1. Choose side prematch
	2. Set ping winner preset
	3. Add 1 point in game
	*/
	func singleTap(_ tableSide: TableSide) {
		print("single tap \(String(describing: tableSide))")
		switch status {
		case .guestChooseSide:
			tableSides = TableSides(guestChoice: tableSide)
			status = .ping
		case .ping:
			let server = teamID(tableSide)
			set = GameSet(firstServe: server)
			game = Game(firstService: server, tableSides: tableSides)
			status = .playing
		case .playing:
			switch game.status {
			case .gameOver:
				print("Nothing game over.")
			case .skunk:
				game.status = .gameOver
			default:
				game.addPoint(teamID(tableSide))
			}
		default:
			break
		}
	}
	
	/* Double Tap player side buttons used for:
	1. Remove point in game
	*/
	func doubleTap(_ tableSide: TableSide) {
		let team = teamID(tableSide)
		game.removePoint(team)
	}
	
	func longPress(_ tableSide: TableSide) {
		resetMatch()
	}
	
	func singleTapMiddle() {
		print("single tap middle")
		switch status {
		case .matchComplete, .optionToExtend:
			status = .postgame
			print("POST match and show stats")
		case .postgame:
			status = .pregame
			resetMatch()
			print("Select teams")
		case .pregame:
			status = .guestChooseSide
		case .playing:
			switch game.status {
			case .gameOver:
				closeOutGame()
			case .skunk:
				game.status = .gameOver
			default:
				break
			}
		default:
			break
		}
	}
	
	func doubleTapMiddle() {
		switch status {
		case .optionToExtend:
			extendMatch()
		default:
			break
		}
	}
	
	func resetMatch() {
		homeSets = []
		guestSets = []
		tableSides = tableSides.switched()
		set = GameSet(firstServe: .guest)
		game = Game(firstService: .guest, tableSides: tableSides.switched())
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
			status = .ping
		}
	}
	
	func closeOutMatch() {
		guard let matchWinner = matchWinner else {
			assertionFailure("No winner of match. Do you still want to close?")
			return
		}
		if matchType.pointGoal < MatchType.bestOfSeven.pointGoal {
			print("give option to extend")
			status = .optionToExtend
		} else {
			print("Winner \(String(describing: matchWinner))")
			status = .matchComplete
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
			return
		}
		status = .ping
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
	
	var serviceSide: TableSide {
		switch game.service {
		case .home:
			return tableSides.home
		case .guest:
			return tableSides.guest
		}
	}

	var statusText: String? {
		switch status {
		case .playing:
			return game.status.statusText
		default:
			return status.statusText
		}
	}
}

extension Match {
	enum Status: Int, CaseIterable {
		case pregame
		case guestChooseSide
		case ping
		case playing
		case optionToExtend
		case matchComplete
		case postgame
	
		var statusText: String? {
			switch self {
			case .guestChooseSide:
				return "Guest, choose a side."
			case .optionToExtend:
				return "Do you want to extend the match?"
			default:
				return nil
			}
		}
	}
}
	

