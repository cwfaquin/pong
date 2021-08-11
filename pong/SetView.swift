//
//  SetView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct SetView: View {
	
	@ObservedObject var match: Match
	
		var body: some View {
			HStack(spacing: 20) {
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.tableSides.home, currentScore: match.setScore.home, winningScore: match.setScore.pointGoal))
				Text("GAMES")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: match.setScore.guest, winningScore: match.setScore.pointGoal))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.fixedSize(horizontal: false, vertical: false)
		}
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(match: Match())
    }
}
