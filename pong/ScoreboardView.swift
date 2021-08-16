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
	
	let height: CGFloat = UIScreen.main.bounds.height
	let seg: CGFloat = Config.height/10
	let panelWidth: CGFloat = Config.width * 2/5
	let middleWidth: CGFloat = Config.width/5
	
	var columns = [GridItem(), GridItem()]
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
			HStack {
				makeGroup(.left)
				Rectangle()
					.foregroundColor(.black)
					.frame(width: geo.size.width/8)
				makeGroup(.right)
			}
				VStack {
					Spacer(minLength: geo.size.height/5)
					HStack {
						SeriesScoreView(viewModel: homeSetVM)
						Text("SET")
							.font(.system(size: 50, weight: .regular, design: .monospaced))
							.frame(width: geo.size.width/8)
						SeriesScoreView(viewModel: guestSetVM)
					}
					HStack {
						SeriesScoreView(viewModel: homeMatchVM)
						Text("MATCH")
							.font(.system(size: 50, weight: .regular, design: .monospaced))
							.frame(width: geo.size.width/8)
						SeriesScoreView(viewModel: guestMatchVM)
					}
					Divider()
						.frame(width: geo.size.width/9)
					Spacer(minLength: geo.size.height/2)
				}
			}
		}
	}
	
	func makeGroup(_ tableSide: TableSide) -> some View {
		let id = match.teamID(tableSide)
		let score = id == .home ? match.game.home : match.game.guest
		return GroupBox {
			Text(id.rawValue.uppercased())
				.font(.system(size: 100, weight: .semibold, design: .monospaced))
				.padding()
			Divider()
			HStack {
				switch tableSide {
				case .left:
					Text(String(score))
						.font(.system(size: 700, weight: .bold, design: .rounded))
						.layoutPriority(1)
					Rectangle()
						.foregroundColor(.clear)
				case .right:
					Rectangle()
						.foregroundColor(.clear)
					Text(String(score))
						.font(.system(size: 700, weight: .bold, design: .rounded))
						.layoutPriority(1)
				}
			}
		}.layoutPriority(1)
	}
	
	/*	.navigationBarTitle("\(match.set.home.count) - \(match.set.guest.count)")
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
	 )*/
	
	
	
	
	//.navigationViewStyle(StackNavigationViewStyle())
	//.toolbar(content: toolBarItemGroup)
	
	
	var homeSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: match.tableSides.home, currentScore: match.homeSets.count, winningScore: match.set.setType.pointGoal)
	}
	
	var guestSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: match.set.guest.count, winningScore: match.set.setType.pointGoal)
	}
	
	var homeMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: match.tableSides.home, currentScore: match.homeSets.count, winningScore: match.matchType.pointGoal)
	}
	
	var guestMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: match.tableSides.guest, currentScore: match.guestSets.count, winningScore: match.matchType.pointGoal)
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
