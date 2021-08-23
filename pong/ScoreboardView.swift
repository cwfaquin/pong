//
//  ScoreboardView.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI

struct ScoreboardView: View {

	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

	@EnvironmentObject var settings: MatchSettings
	@EnvironmentObject var match: Match
	@ObservedObject var viewModel: ScoreboardVM
	@State var showSettings: Bool = false
	
	var body: some View {
			
			VStack {
					TeamsView(showSettings: $showSettings)
					SeriesView(viewModel: SeriesVM(match, seriesType: .set))
					SeriesView(viewModel: SeriesVM(match, seriesType: .match))
				ScoresView(viewModel: ScoresVM(match))
					.layoutPriority(1)
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
	}
				
		
		
			
		/*	VStack {
				Spacer()
				PossessionArrow(match: match)
					.frame(width: match.middlePanelWidth * 3)
					.padding()
			}
			if let statusText = statusText {
				makeStatusView(statusText)
					.padding()
			}
			if showSettings {
					SettingsView(
						viewModel: SettingsVM(),
							gameType: $match.game.gameType,
							setType: $match.set.setType,
							matchType: $match.matchType,
							showSettings: $showSettings
					).padding(100)
				}
		
		.background(Color.black)
		*/
	

	
	
	
	func makeStatusView(_ text: String) -> some View {
		GroupBox {
			Text(text)
				.font(.system(size: 50, weight: .regular, design: .monospaced))
				.foregroundColor(.green)
				.shadow(color: .green, radius: 1, x: 0, y: 0)
				.frame(maxWidth: .infinity)
				.padding()
		}
		.frame(width: match.geoSize.width/2.25)
		.groupBoxStyle(BlackGroupBoxStyle(color: .black.opacity(0.9)))
		.overlay(
					 RoundedRectangle(cornerRadius: 10)
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
