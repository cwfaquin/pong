//
//  MatchView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct MatchView: View {
	
	@EnvironmentObject var match: Match
	@EnvironmentObject var settings: MatchSettings
	
    var body: some View {
			HStack(spacing: 20) {
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .left, currentScore: match.matchScore.home, winningScore: settings.matchType.pointGoal))
				Text("SETS")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: .right, currentScore: match.matchScore.guest, winningScore: settings.matchType.pointGoal))
			}
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
