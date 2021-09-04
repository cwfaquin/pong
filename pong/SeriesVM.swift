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
	@Published var panelWidth: CGFloat
	private let seriesType: SeriesType
	
	init(_ match: Match, seriesType: SeriesType, panelWidth: CGFloat) {
		self.match = match
		self.seriesType = seriesType
		self.panelWidth = panelWidth
	}
	
	func text(_ seriesType: SeriesType) -> String {
		switch seriesType {
		case .set:
			return "games".uppercased().spaced
		case .match:
			return "sets".uppercased().spaced
		}
	}
	
	var text: String {
		switch seriesType {
		case .set:
			return "games".uppercased().spaced
		case .match:
			return "sets".uppercased().spaced
		}
	}
	
	var circleCount: Int {
		max(match.set.setType.pointGoal, match.matchType.pointGoal)
	}
	
	func leftScoreVM(_ seriesType: SeriesType) -> SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.left, currentScore: setScore(.left), winningScore: match.set.setType.pointGoal, circleCount: circleCount)
		case .match:
			return SeriesScoreVM(.left, currentScore: matchScore(.left), winningScore: match.matchType.pointGoal, circleCount: circleCount)
		}
	}
	
	func rightScoreVM(_ seriesType: SeriesType) -> SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.right, currentScore: setScore(.right), winningScore: match.set.setType.pointGoal, circleCount: circleCount)
		case .match:
			return SeriesScoreVM(.right, currentScore: matchScore(.right), winningScore: match.matchType.pointGoal, circleCount: circleCount)
		}
	}

	var leftScoreVM: SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.left, currentScore: setScore(.left), winningScore: match.set.setType.pointGoal, circleCount: circleCount)
		case .match:
			return SeriesScoreVM(.left, currentScore: matchScore(.left), winningScore: match.matchType.pointGoal, circleCount: circleCount)
		}
	}
	
	var rightScoreVM: SeriesScoreVM {
		switch seriesType {
		case .set:
			return SeriesScoreVM(.right, currentScore: setScore(.right), winningScore: match.set.setType.pointGoal, circleCount: circleCount)
		case .match:
			return SeriesScoreVM(.right, currentScore: matchScore(.right), winningScore: match.matchType.pointGoal, circleCount: circleCount)
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
