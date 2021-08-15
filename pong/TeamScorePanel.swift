//
//  HomeScoreView.swift
//  HomeScoreView
//
//  Created by Charles Faquin on 8/14/21.
//

import SwiftUI

struct TeamScorePanel: View {
	
	@ObservedObject var match: Match
	
	let id: TeamID

    var body: some View {
			
			GeometryReader { geo in

			LazyVStack {

					Text(teamName.uppercased())
						.font(.largeTitle)
						.fontWeight(.heavy)
						//.alignmentGuide(VerticalAlignment.center) { _ in 0 }
						.frame(width: geo.size.width, height: geo.size.height * 0.2)
				
					SeriesScoreView(viewModel: setVM)
					//	.alignmentGuide(VerticalAlignment.center) { _ in 0 }
						.frame(width: geo.size.width, height: geo.size.height * 0.1, alignment: .trailing)
					
					SeriesScoreView(viewModel: matchVM)
						//.alignmentGuide(VerticalAlignment.center) { _ in 0 }
						.frame(width: geo.size.width, height: geo.size.height * 0.1, alignment: .trailing)
					
					Text(String(score))
					.font(.largeTitle)
				//	.font(.system(size: geo.size.height * 0.5 , weight: .bold, design: .rounded))
					//	.alignmentGuide(VerticalAlignment.center) { _ in 0 }
						.frame(width: geo.size.width, height: geo.size.height * 0.5)
					
			}
			.onAppear {
					print(geo, word: "TEAM PANEL")
			}
		}
	}
	
	
	var setVM: SeriesScoreVM {
		switch id {
		case .home:
			return SeriesScoreVM(tableSide: match.tableSides.home, currentScore: match.homeSets.count, winningScore: match.set.setType.pointGoal)
		case .guest:
			return SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: match.set.guest.count, winningScore: match.set.setType.pointGoal)

		}
	}

	var matchVM: SeriesScoreVM {
		switch id {
		case .home:
			return SeriesScoreVM(tableSide: match.tableSides.home, currentScore: match.homeSets.count, winningScore: match.matchType.pointGoal)
		case .guest:
			return SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: match.guestSets.count, winningScore: match.matchType.pointGoal)
		}
	}

	var tableSide: TableSide {
		switch id {
		case .home:
			return match.tableSides.home
		case .guest:
			return match.tableSides.guest
		}
	}
	
	var teamName: String {
		switch id {
		case .home:
			return match.home.user?.teamName ?? match.home.id.rawValue
		case .guest:
			return match.guest.user?.teamName ?? match.guest.id.rawValue
		}
	}
	
	var score: Int {
		switch id {
		case .home:
			return match.game.home
		case .guest:
			return match.game.guest
		}
	}
	
	var setScore: Int {
		switch id {
		case .home:
			return match.set.home.count
		case .guest:
			return match.set.guest.count
		}
	}
	
	var matchScore: Int {
		switch id {
		case .home:
			return match.homeSets.count
		case .guest:
			return match.guestSets.count
		}
	}
}

struct TeamScorePanel_Previews: PreviewProvider {
    static var previews: some View {
			TeamScorePanel(match: Match(), id: .home)
    }
}
