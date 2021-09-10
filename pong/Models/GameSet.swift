//
//  Set.swift
//  pong
//
//  Created by Charles Faquin on 8/14/21.
//

import Foundation

struct GameSet {
	let firstServe: TeamID
	var home = [Game]()
	var guest = [Game]()
	var setType: SetType
	
	init(_ setType: SetType, firstServe: TeamID) {
		self.setType = setType
		self.firstServe = firstServe
	}
	
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
	
	mutating func removeGame(_ winner: TeamID, startDate: Date) {
		switch winner {
		case .home:
			home = home.filter { $0.startDate != startDate }
		case .guest:
			guest = guest.filter { $0.startDate != startDate }
		}
	}
}
