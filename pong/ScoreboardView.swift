//
//  ScoreboardView.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI
import flic2lib

struct ScoreboardView: View {
	
	@EnvironmentObject var match: Match
	@EnvironmentObject var buttonManager: PongAppVM
	@State var showSettings = false
	@State var showPlayerSelection = false
	@State var statusVM = StatusVM(text: "", temporary: true)
	@State var showStatus = false
	@State var screenSize = UIScreen.main.bounds.size
	@State var showHomeSelection = false
	@State var showGuestSelection = false

	var body: some View {
		
		ZStack {
			
			VStack {
				TeamsView(showSettings: $showSettings, showButtonManager: $buttonManager.scanViewVisible, panelWidth: panelWidth, showHomeSelection: $showHomeSelection, showGuestSelection: $showGuestSelection)
				SeriesView(viewModel: SeriesVM(match, seriesType: .set, panelWidth: panelWidth))
				SeriesView(viewModel: SeriesVM(match, seriesType: .match, panelWidth: panelWidth))
				ScoresView(screenSize: $screenSize)
			}
			
			VStack {
				Spacer()
				ServiceView(viewModel: ServiceVM(match, panelWidth: panelWidth))
			}
			
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
				settings: $match.settings,
				showSettings: $showSettings
			)
		})

		.sheet(
			isPresented: $buttonManager.scanViewVisible,
			onDismiss: {
				
			},
			content: {
				ButtonsView()
					.environmentObject(buttonManager)
			}
		)
		.sheet(isPresented: $showHomeSelection) {
			PlayerSelectionView(selectedPlayer: $match.settings.homeTeam.playerOne, isShowing: $showHomeSelection, teamID: .home)
		}
		.sheet(isPresented: $showGuestSelection) {
			PlayerSelectionView(selectedPlayer: $match.settings.guestTeam.playerOne, isShowing: $showGuestSelection, teamID: .guest)
		}
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
		if UIScreen.main.bounds.width <= 1024 {
			return screenSize.width/6
		} else {
			return .panelWidth(screenSize.width)
		}
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
			.environmentObject(PongAppVM())
	}
}

enum ToolbarButton: String, CaseIterable {
	case settings = "gear"
	case plus
	case minus
}
