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
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .left, currentScore: match.matchScore.home, winningScore: match.matchScore.pointGoal))
				Text("SETS")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .right, currentScore: match.matchScore.guest, winningScore: match.matchScore.pointGoal))
			}
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(match: Match())
    }
}
