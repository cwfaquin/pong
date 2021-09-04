//
//  Set.swift
//  pong
//
//  Created by Charles Faquin on 8/14/21.
//

import Foundation

struct Set {
	let firstServe: TeamID
	var home = [Game]()
	var guest = [Game]()
	var setType: SetType = .bestOfFive
	
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
