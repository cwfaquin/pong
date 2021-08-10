//
//  Player.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Combine
import SwiftUI

final class Team: ObservableObject {

	@Published var lastFlic: FlicAction?
	@Published var user: User?
	@Published var isServing: Bool
	@Published var color: UIColor
	@Published var tableSide: TableSide
	@Published var gameScore: Int = 0
	@Published var setScore: Int = 0
	@Published var matchScore: Int = 0
	
	let id: TeamID
		
	init(_ id: TeamID) {
		self.id = id
		switch id {
		case .home:
			color = .systemBlue
			isServing = true
			tableSide = .left
		case .guest:
			color = .systemPink
			isServing = false
			tableSide = .right
		}
	}
}

extension Team: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(isServing)
		hasher.combine(lastFlic)
		hasher.combine(color)
	}
	
	static func == (lhs: Team, rhs: Team) -> Bool {
		return lhs.id == rhs.id
	}
}

enum TeamID: String, CaseIterable {
	case home
	case guest
}
