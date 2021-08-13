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
			HStack(spacing: 20) {
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .left, currentScore: leftScore, winningScore: match.matchType.pointGoal))
				Text(" SETS ")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .right, currentScore: rightScore, winningScore: match.matchType.pointGoal))
			}
    }
	
	var leftScore: Int {
		switch match.tableSides.home {
		case .left:
			return match.homeSets.count
		case .right:
			return match.guestSets.count
		}
	}
	
	var rightScore: Int {
		switch match.tableSides.guest {
		case .left:
			return match.homeSets.count
		case .right:
			return match.guestSets.count
		}
	}
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match())
    }
}
