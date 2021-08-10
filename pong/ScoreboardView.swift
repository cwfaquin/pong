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
				ScoreView(gameScore: match.gameScore, gameSide: match.gameSide)
				SetView()
				MatchView()
				Spacer()
			}
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
		.navigationBarTitleDisplayMode(.inline)
		.navigationViewStyle(StackNavigationViewStyle())
		
			
	}

	private func buttonTapped() {
		
	}
}

struct ScoreboardView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreboardView(viewModel: ScoreboardVM())
	}
}

