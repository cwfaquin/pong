//
//  ScoreboardView.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI

struct ScoreboardView: View {

	@EnvironmentObject var settings: MatchSettings
	@EnvironmentObject var match: Match
	@ObservedObject var viewModel: ScoreboardVM
	
	@State var date = Date()
	
	var body: some View {
		NavigationView {
			VStack {
				TeamsView()
				Divider()
				ScoreView(match: match)
				SetView(match: match)
				MatchView(match: match)
				Spacer()
					.padding()
			}
			.navigationBarTitle(" ")
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(leading: Button(action: {
			}) {
					Text(date, style: .time)
						.foregroundColor(.white)
						.font(.body)
				}, trailing: Button(action: {
			}) {
					Image(systemName: "gear")
						.foregroundColor(.purple)
						.imageScale(.large)
				}
			)
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.toolbar(content: toolBarItemGroup)
	}
	
	func toolBarItemGroup() -> some ToolbarContent {
		ToolbarItemGroup(placement: .bottomBar) {
			ForEach(0..<ToolbarButton.allCases.count) { index in
				Button(action: {
								buttonAction(index)
				}, label: {
					switch ToolbarButton.allCases[index] {
					case .spacer, .spacer1, .spacer2, .spacer3:
						Spacer()
					default:
					Image(systemName: "\(ToolbarButton.allCases[index].rawValue).circle")
						.imageScale(.large)
						.foregroundColor(.purple)
					}
				})
			}
		}
	}
	
	func buttonAction(_ index: Int) {
		switch ToolbarButton.allCases[index] {
		case .plus:
			match.incrementGameScore(1, team: .home)
		case .minus:
			match.incrementGameScore(1, team: .guest)
		case .pause:
			print("pause")
		case .play:
			print("play")
		case .restart:
			match.gameScore.home = 0
			match.gameScore.guest = 0
		default:
			break
		}
	}
	
}

struct ScoreboardView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreboardView(viewModel: ScoreboardVM())
	}
}

enum ToolbarButton: String, CaseIterable {
	case plus
	case spacer
	case minus
	case spacer1
	case restart
	case spacer2
	case pause
	case spacer3
	case play
	

}
