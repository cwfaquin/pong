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
	@State var showSettings: Bool = false
	@State var screenSize = UIScreen.main.bounds.size

	
	var body: some View {
	
		ZStack {
		VStack {
				TeamsView(match: match, showSettings: $showSettings, panelWidth: panelWidth)
				SeriesView(viewModel: SeriesVM(match, seriesType: .set, panelWidth: panelWidth))
				SeriesView(viewModel: SeriesVM(match, seriesType: .match, panelWidth: panelWidth))
			ScoresView(viewModel: ScoresVM(match, screenSize: screenSize))
			}

			VStack {
			Spacer()
			ServiceView(viewModel: ServiceVM(match, panelWidth: panelWidth))
				
			}.padding()
			
			if let statusText = statusText {
				makeStatusView(statusText)
			}
		}
		
			.background(Color.black)
		

			.sheet(isPresented: $showSettings, onDismiss: nil, content: {
				SettingsView(
					viewModel: SettingsVM(),
					gameType: $match.game.gameType,
					setType: $match.set.setType,
					matchType: $match.matchType,
					showSettings: $showSettings
				)
			})
		
		
			.onRotate { newOrientation in
				screenSize = UIScreen.main.bounds.size
			}
			
	}
	
	var panelWidth: CGFloat {
		.panelWidth(screenSize.width)
	}
	

	
	func makeStatusView(_ text: String) -> some View {
		GroupBox {
			Text(text)
				.font(.system(size: 50, weight: .regular, design: .monospaced))
				.foregroundColor(.green)
				.shadow(color: .green, radius: 1, x: 0, y: 0)
				.fixedSize(horizontal: false, vertical: false)
				.padding()
		}.padding()
			.groupBoxStyle(BlackGroupBoxStyle(color: .clear))
			.background(Color.black.opacity(0.9))
			.cornerRadius(12)
		.overlay(
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color.white, lineWidth: 4)
				.shadow(color: .white, radius: 2, x: 0, y: 0)
		)
	}
	
	func makeScoreView(_ tableSide: TableSide) -> some View {
		Text(String(gameScore(tableSide)))
			.font(.system(size: 500, weight: .bold, design: .rounded))
			.lineLimit(1)
			.minimumScaleFactor(0.25)
			.padding()
			.shadow(color: .white, radius: 4, x: 0, y: 0)
	}
	
	func gameScore(_ tableSide: TableSide) -> Int {
		let id = match.teamID(tableSide)
		return id == .home ? match.game.home : match.game.guest
	}
	
	var statusText: String? {
		switch match.status {
		case .ping:
			return "Ping it up!"
		case .guestChooseSide:
			return "Guest, please choose a side."
		case .optionToExtend:
			return "Do you want to extend the match?"
		case .playing:
			switch match.game.status {
			case .deuce, .deuceOT:
				return "D E U C E!"
			case .adOut:
				return "Advantage Out"
			case .gamePoint:
				return "Game Point!"
			case .gameOver:
				return match.game.skunk ? "🦨 Skunked!? You stink! 🦨" : "G A M E  O V E R"
			default:
				return nil
			}
		default:
			return nil
		}
	}
}

struct ScoreboardView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreboardView(viewModel: ScoreboardVM())
	}
}

enum ToolbarButton: String, CaseIterable {
	case settings = "gear"
	case plus
	case minus
}
