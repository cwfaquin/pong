//
//  MatchView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct MatchView: View {
	
	@ObservedObject var match: Match
	
	var body: some View {
		HStack {
			SeriesScoreView(viewModel: leftMatchVM)
			Divider()
				.frame(minHeight: 15, idealHeight: 70, maxHeight: 80)
			Text("S E T S")
				.font(.system(size: 50, weight: .ultraLight, design: .rounded))
				.minimumScaleFactor(0.25)
				.frame(width: match.middlePanelWidth)
				.shadow(color: .white, radius: 2, x: 0, y: 0)
			Divider()
				.frame(minHeight: 15, idealHeight: 70, maxHeight: 80)
			
			SeriesScoreView(viewModel: rightMatchVM)
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
	
	var leftMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .left, currentScore: matchScore(.left), winningScore: match.matchType.pointGoal)
	}
	
	var rightMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .right, currentScore: matchScore(.right), winningScore: match.matchType.pointGoal)
	}
}

struct MatchView_Previews: PreviewProvider {
	static var previews: some View {
		MatchView(match: Match())
	}
}
