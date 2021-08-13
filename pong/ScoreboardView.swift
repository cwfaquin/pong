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
					match.singleTapMiddle()
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
					case .spacer, .spacer1, .spacer2:
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
			match.singleTap(.left)
		case .minus:
			match.singleTap(.right)
		case .play:
			match.doubleTap(.left)
		case .pause:
			match.doubleTap(.right)
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
	case play
	case spacer2
	case pause
}
