//
//  Score.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

final class Match: ObservableObject {

	@Published var gameStatus: GameStatus = .pregame
	@Published var setStatus: SetStatus = .pregame
	@Published var matchStatus: MatchStatus = .pregame
	@Published var service: TeamID = .guest
	@Published var home: Team = Team(.home)
	@Published var guest: Team = Team(.guest)
	@Published var gameScore: Score = Score()
	@Published var setScore: Score = Score()
	@Published var matchScore: Score = Score()
	@Published var gameSide: GameSide = GameSide()

	

	func startMatch(with settings: MatchSettings) {
		
	}
	
	func didUpdateSettings(_ settings: MatchSettings) {
		
	}
	
	func singleTap(_ sender: TeamID) {
		
	}
	
	func doubleTap(_ sender: TeamID) {
		
	}
	
	func longPress(_ sender: TeamID) {
		
	}
	
}

struct Score {
	var home: Int = 0
	var guest: Int = 0
	
	mutating func reset() {
		home = 0
		guest = 0
	}
}

struct GameSide {
	var home: TableSide = .left
	var guest: TableSide = .right
	
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
