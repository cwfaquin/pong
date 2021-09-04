//
//  ScoreVM.swift
//  ScoreVM
//
//  Created by Charles Faquin on 8/22/21.
//

import Foundation
import SwiftUI

final class ScoresVM: ObservableObject {
	
	@ObservedObject var match: Match
	@Published var screenSize: CGSize
	
	init(_ match: Match, screenSize: CGSize) {
		self.match = match
		self.screenSize = screenSize
	}
	
	func scoreImageName(_ tableSide: TableSide) -> String {
		"\(scoreText(tableSide)).circle.fill"
	}

	func scoreText(_ tableSide: TableSide) -> String {
		switch match.teamID(tableSide) {
		case .home:
			return String(match.game.home)
		case .guest:
			return String(match.game.guest)
		}
	}
	
	var serviceText: String {
		switch match.status {
		case .ping:
			return "ping".uppercased().spaced
		default:
			return "service".uppercased().spaced
		}
	}
	
	var textColor: Color {
		switch match.status {
		case .ping:
			return .green
		default:
			return .white
		}
	}
	
	func arrowImageName(_ tableSide: TableSide) -> String {
		let base = "arrowtriangle.\(tableSide.text)"
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return base
		default:
			return tableSide == match.serviceSide ? "\(base).fill" : base
		}
	}
	
	func imageColor(_ side: TableSide) -> Color {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return .gray
		default:
			return side == match.serviceSide ? .green : .gray
		}
	}
	
	func shadowRadius(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return 0
		default:
			return side == match.serviceSide ? 5 : 0
		}
	}

}
