//
//  Score.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI


final class Match: ObservableObject {
	
	@Published var settings = MatchSettings()
	@Published var status: Status = .pregame
	@Published var tableSides = TableSides()
	@Published var game: Game = Game(.long, firstService: .guest, tableSides: TableSides())
	@Published var set: GameSet = GameSet(.bestOfThree, firstServe: .guest)
	@Published var homeSets = [GameSet]()
	@Published var guestSets = [GameSet]()
	var cancellable = Set<AnyCancellable>()

	init() {
		$settings
			.sink { newValue in
				self.game.gameType = newValue.gameType
				self.set.setType = newValue.setType
			}
			.store(in: &cancellable)
	}
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
			set = GameSet(settings.setType, firstServe: server)
			game = Game(settings.gameType, firstService: server, tableSides: tableSides)
			status = .playing
		case .gameOverSwitchSides, .matchComplete:
			break
		case .playing:
			switch game.status {
			case .skunk:
				game.status = .gameOver
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					self.postgameMatchStatus()
				}
			default:
				game.addPoint(teamID(tableSide))
				checkGameOver()
				if game.status == .gameOver {
					postgameMatchStatus()
				}
			}
		default:
			break
		}
	}
	
	/* Double Tap player side buttons used for:
	1. Remove point in game
	*/
	func doubleTap(_ tableSide: TableSide) {
		switch game.status {
		case .gameOver, .skunk:
			if let gameWinner = game.winner {
				if let setWinner = set.winner {
					switch setWinner {
					case .home:
						_ = homeSets.removeLast()
					case .guest:
						_ = guestSets.removeLast()
					}
				}
				set.removeGame(gameWinner, startDate: game.startDate)
				status = .playing
			}
		default:
			break
		}
		let team = teamID(tableSide)
		game.removePoint(team)
	}
	
	func longPress(_ tableSide: TableSide) {
		resetMatch()
	}
	
	func singleTapMiddle() {
		print("single tap middle")
		switch status {
		case .matchComplete:
			status = .postgame
		case .postgame:
			status = .pregame
			resetMatch()
		case .pregame:
			status = .guestChooseSide
		case .gameOverSwitchSides:
			let firstService = game.secondService
			tableSides = tableSides.switched()
			if set.setComplete {
				status = .ping
			} else {
				status = .playing
				game = Game(settings.gameType, firstService: firstService, tableSides: tableSides)
			}
		default:
			break
		}
		print(status)
	}
	
	func doubleTapMiddle() {
		print("double tap middle")
	}
	
	func checkGameOver() {
		guard let gameWinner = game.winner else { return }
		set.addGame(game, winner: gameWinner)
		if let setWinner = set.winner {
			switch setWinner {
			case .home:
				homeSets.append(set)
			case .guest:
				guestSets.append(set)
			}
		}
	}
	
	func resetMatch() {
		homeSets = []
		guestSets = []
		tableSides = tableSides.switched()
		set = GameSet(settings.setType, firstServe: .guest)
		game = Game(settings.gameType, firstService: .guest, tableSides: tableSides.switched())
	}
	
	func postgameMatchStatus() {
		if matchTotalReached {
			status = .matchComplete
		} else {
			status = .gameOverSwitchSides
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
		homeSets.count == settings.matchType.pointGoal ||
		guestSets.count == settings.matchType.pointGoal
	}
	
 	var serviceSide: TableSide {
		switch game.service {
		case .home:
			return tableSides.home
		case .guest:
			return tableSides.guest
		}
	}
}

extension Match {
	enum Status: Int, CaseIterable {
		case pregame
		case guestChooseSide
		case ping
		case playing
		case gameOverSwitchSides
		case matchComplete
		case postgame
	
		var statusVM: StatusVM? {
			switch self {
			case .guestChooseSide:
				return StatusVM(text: "Guest, choose a side.", temporary: false)
			case .ping:
				return StatusVM(text: "Ping it up!", temporary: true)
			case .matchComplete:
				return StatusVM(text: "GAME. SET. MATCH.", temporary: false)
			case .gameOverSwitchSides:
				return StatusVM(text: "Switch sides".uppercased(), temporary: false)
			default:
				return nil
			}
		}
		
		var textColor: Color {
			switch self {
			case .pregame, .ping, .guestChooseSide:
				return .gray
			default:
				return .white
			}
		}
		
		var circleColor: Color {
			switch self {
			case .pregame, .ping, .guestChooseSide:
				return .gray
			default:
				return Color(UIColor.cyan)
			}
		}
		
		var shadowRadious: CGFloat {
			switch self {
			case .pregame, .ping, .guestChooseSide:
				return 0
			default:
				return 5
			}
		}
	}
}
	

