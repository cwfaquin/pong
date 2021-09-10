//
//  ScoreboardView.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI

struct ScoreboardView: View {
	
	@EnvironmentObject var match: Match
	@State var showSettings: Bool = false
	@State var statusVM: StatusVM = StatusVM(text: "", temporary: true)
	@State var showStatus: Bool = false
	
	@State var screenSize = UIScreen.main.bounds.size
	
	var body: some View {
		
		ZStack {
			
			VStack {
				TeamsView(showSettings: $showSettings, panelWidth: panelWidth)
				SeriesView(viewModel: SeriesVM(match, seriesType: .set, panelWidth: panelWidth))
				SeriesView(viewModel: SeriesVM(match, seriesType: .match, panelWidth: panelWidth))
				ScoresView(screenSize: $screenSize)
			}
			
			VStack {
				Spacer()
				ServiceView(viewModel: ServiceVM(match, panelWidth: panelWidth))
			}.padding()
			
			if showStatus {
				VStack {
					Spacer()
					StatusView(showStatus: $showStatus, viewModel: $statusVM)
					Spacer()
				}
				.animation(.easeInOut)
				.transition(.bottomToTop)
			}
				
		}
		.background(Color.black)
		.sheet(isPresented: $showSettings, onDismiss: nil, content: {
			SettingsView(
				viewModel: SettingsVM(),
				settings: $match.settings,
				showSettings: $showSettings
			)
		})
		.onRotate { newOrientation in
			screenSize = UIScreen.main.bounds.size
		}
		.onChange(of: match.status) { matchStatus in
			handleNewState(matchStatus, gameStatus: nil)
		}
		.onChange(of: match.game.status) { gameStatus in
			handleNewState(nil, gameStatus: gameStatus)
		}
	}
	
	
	var panelWidth: CGFloat {
		.panelWidth(screenSize.width)
	}
	
	func handleNewState(_ matchStatus: Match.Status?, gameStatus: Game.Status?) {
		let newStatusVM = matchStatus?.statusVM ?? gameStatus?.statusVM
		withAnimation(.easeInOut) {
			if let newStatusVM = newStatusVM {
				statusVM = newStatusVM
			}
			showStatus = newStatusVM != nil
		}
	}
}

struct ScoreboardView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreboardView()
			.environmentObject(Match())
	}
}

enum ToolbarButton: String, CaseIterable {
	case settings = "gear"
	case plus
	case minus
}
