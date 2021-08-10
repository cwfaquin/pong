//
//  SetView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct SetView: View {
	
	@EnvironmentObject var match: Match
	@EnvironmentObject var settings: MatchSettings
	
		var body: some View {
			HStack(spacing: 20) {
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.gameSide.home, currentScore: match.setScore.home, winningScore: settings.setType.pointGoal))
				Text("GAMES")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.gameSide.guest, currentScore: match.setScore.guest, winningScore: settings.setType.pointGoal))
			}
		}
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
