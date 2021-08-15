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

struct Team {
	var user: User?
	var opponent: User?
	var color: UIColor
	var tableSide: TableSide

	let id: TeamID
		
	init(_ id: TeamID) {
		self.id = id
		switch id {
		case .home:
			color = .systemBlue
			tableSide = .left
		case .guest:
			color = .systemPink
			tableSide = .right
		}
	}
}


