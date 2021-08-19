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
				SeriesScoreView(viewModel: leftMatchVM)
				Divider()
					Text("S E T S")
						.font(.system(size: 50, weight: .ultraLight, design: .rounded))
						.frame(width: match.middlePanelWidth)
				Divider()
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
