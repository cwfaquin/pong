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
	
	init(_ match: Match) {
		self.match = match
	}
	
	func imageName(_ tableSide: TableSide) -> String {
		"\(scoreText(tableSide)).circle"
	}

	func scoreText(_ tableSide: TableSide) -> String {
		switch match.teamID(tableSide) {
		case .home:
			return String(match.game.home)
		case .guest:
			return String(match.game.guest)
		}
	}

}
