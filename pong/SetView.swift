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
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.tableSides.home, currentScore: leftScore, winningScore: match.set.setType.pointGoal))
				Text("GAMES")
				SeriesScoreView(viewModel: SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: rightScore, winningScore: match.set.setType.pointGoal))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.fixedSize(horizontal: false, vertical: false)
		}
	
	var leftScore: Int {
		switch match.tableSides.home {
		case .left:
			return match.set.home.count
		case .right:
			return match.set.guest.count
		}
	}
	
	var rightScore: Int {
		switch match.tableSides.guest {
		case .left:
			return match.set.home.count
		case .right:
			return match.set.guest.count
		}
	}
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(match: Match())
    }
}
