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
				SeriesScoreView(viewModel: leftSetVM)
				Divider()
					Text("G A M E S")
						.font(.system(size: 50, weight: .ultraLight, design: .rounded))
						.frame(width: match.middlePanelWidth)
				Divider()

				SeriesScoreView(viewModel: rightSetVM)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.fixedSize(horizontal: false, vertical: false)
		}
	
	var leftSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .left, currentScore: setScore(.left), winningScore: match.set.setType.pointGoal)
	}
	
	var rightSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .right, currentScore: setScore(.right), winningScore: match.set.setType.pointGoal)
	}
	
	func setScore(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return match.set.home.count
		case .guest:
			return match.set.guest.count
		}
	}
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(match: Match())
    }
}
