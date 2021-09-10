//
//  SeriesVM.swift
//  SeriesVM
//
//  Created by Charles Faquin on 8/22/21.
//

import Combine
import SwiftUI

class SeriesVM: ObservableObject {
	
	@Published var match: Match
	@Published var panelWidth: CGFloat
	@Published var leftScoreCircles = [CircleScoreVM]()
	@Published var rightScoreCircles = [CircleScoreVM]()

	let seriesType: SeriesType
	
	private let empty: String = "circle"
	private let filled: String = "largecircle.fill.circle"
	
	init(_ match: Match, seriesType: SeriesType, panelWidth: CGFloat) {
		self.match = match
		self.seriesType = seriesType
		self.panelWidth = panelWidth
		updateScoreCircles()
	}
	
	func updateScoreCircles() {
		leftScoreCircles = scoreCircles(.left)
		rightScoreCircles = scoreCircles(.right)
	}
	
	var text: String {
		switch seriesType {
		case .set:
			return "games".uppercased().spaced
		case .match:
			return "sets".uppercased().spaced
		}
	}
	
	var textShadowRadius: CGFloat {
		switch match.status {
		case .pregame, .ping, .guestChooseSide:
			return 0
		default:
			return 2
		}
	}
	
	private var setGoal: Int {
		match.settings.setType.pointGoal
	}
	
	private var matchGoal: Int {
		match.settings.matchType.pointGoal
	}
	
	var pointGoal: Int {
		switch seriesType {
		case .set:
			return setGoal
		case .match:
			return matchGoal
		}
	}
	
	var circleCount: Int {
		max(setGoal, matchGoal)
	}

	func scoreCircles(_ tableSide: TableSide) -> [CircleScoreVM] {
		Array(0..<circleCount)
			.compactMap {
				 CircleScoreVM(
					index: $0,
					systemName: names(tableSide)[$0],
					color: colors(tableSide)[$0],
					shadowRadius: match.status.shadowRadious
				 )
			}
	}
	
	func colors(_ tableSide: TableSide) -> [Color] {
		let colors = Array(0..<circleCount)
			.compactMap {	$0 + 1 <= pointGoal ? match.status.circleColor : .clear }
		switch tableSide {
		case .left:
			return colors.reversed()
		case .right:
			return colors
		}
	}
	
	func names(_ tableSide: TableSide) -> [String] {
		let names = Array(0..<circleCount)
			.compactMap { $0 + 1 <= score(tableSide) ? filled : empty }
		switch tableSide {
		case .left:
			return names.reversed()
		case .right:
			return names
		}
	}
		
	func score(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return seriesType == .set ? match.set.home.count : match.homeSets.count
		case .guest:
			return seriesType == .set ? match.set.guest.count : match.guestSets.count
		}
	}

	enum SeriesType: String, CaseIterable {
		case set
		case match
	}
}
