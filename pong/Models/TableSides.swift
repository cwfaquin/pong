//
//  TableSides.swift
//  pong
//
//  Created by Charles Faquin on 8/14/21.
//

import Foundation

enum TableSide: Int, CaseIterable {
	case left
	case right
	
	var text: String {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		}
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
