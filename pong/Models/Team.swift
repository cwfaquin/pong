//
//  Player.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Combine
import SwiftUI

enum TeamID: String, CaseIterable {
	case home
	case guest
	
	var systemName: String {
		switch self {
		case .home:
			return "house.circle"
		case .guest:
			return "location.circle"
		}
	}
}

struct Team: Equatable {
	
	var playerOne: Player?
	var playerTwo: Player?
	let id: TeamID
		
	init(_ id: TeamID) {
		self.id = id
	}
	
	mutating func updatePlayerOne(_ player: Player?) {
		playerOne = player
	}
	
	mutating func updatePlayerTwo(_ player: Player?) {
		playerTwo = player
	}
}

