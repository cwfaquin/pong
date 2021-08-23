//
//  SeriesVM.swift
//  SeriesVM
//
//  Created by Charles Faquin on 8/22/21.
//

import Combine
import SwiftUI

class SeriesVM: ObservableObject {
	
	@ObservedObject var match: Match
	private let seriesType: SeriesType
	
	init(_ match: Match, seriesType: SeriesType) {
		self.match = match
		self.seriesType = seriesType
	}
	
	var text: String {
		switch seriesType {
		case .set:
			return "games".uppercased().spaced
		case .match:
			return "sets".uppercased().spaced
		}
	}

	var leftScoreVM: SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.left, currentScore: setScore(.left), winningScore: match.set.setType.pointGoal)
		case .match:
			return SeriesScoreVM(.left, currentScore: matchScore(.left), winningScore: match.matchType.pointGoal)
		}
	}
	
	var rightScoreVM: SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.right, currentScore: setScore(.right), winningScore: match.set.setType.pointGoal)
		case .match:
			return SeriesScoreVM(.right, currentScore: matchScore(.right), winningScore: match.matchType.pointGoal)
		}
	}
	
	func setScore(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return match.set.home.count
		case .guest:
			return match.set.guest.count
		}
	}
	
	func matchScore(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return match.homeSets.count
		case .guest:
			return match.guestSets.count
		}
	}
	
	enum SeriesType: String, CaseIterable {
		case set
		case match
	}
}
