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
	@StateObject var buttonManager = ButtonManager()
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
			).environmentObject(buttonManager)
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
		.onAppear {
			if !Storage.isMacApp {
				buttonManager.configure(self)
			}
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

extension ScoreboardView: ButtonContract {
	func singleClick(_ tableSide: TableSide?) {
		if let tableSide = tableSide {
			match.singleTap(tableSide)
		} else {
			match.singleTapMiddle()
		}
	}
	
	func doubleClick(_ tableSide: TableSide?) {
		if let tableSide = tableSide {
			match.doubleTap(tableSide)
		} else {
			match.doubleTapMiddle()
		}
	}
	
	func longPress(_ tableSide: TableSide?) {
		print(#function)
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
