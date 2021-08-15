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

		HStack {
			GroupBox {
				Text(match.home.id.rawValue.uppercased())
					.font(.system(size: 50, weight: .semibold, design: .monospaced))
					.padding()
				//GroupBox {
				
					Text(String(match.game.home))
					.font(.system(size: 700, weight: .bold, design: .rounded))

			}
			
			
			GroupBox {
				Text(match.guest.id.rawValue.uppercased())
					.font(.system(size: 50, weight: .semibold, design: .monospaced))
					.padding()
					//.frame(width: .infinity, alignment: .center)
				SeriesScoreView(viewModel: guestSetVM)
				SeriesScoreView(viewModel: guestMatchVM)
				Text(match.guest.id.rawValue.uppercased())
					.font(.largeTitle)
					.fontWeight(.semibold)
					.padding()
				GroupBox {
					Text(String(match.game.guest))
					.font(.system(size: 700, weight: .bold, design: .rounded))
				}
			}
			
		
			
		}
					
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
