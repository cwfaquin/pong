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
		
		return GeometryReader { geo in
			LazyVStack {
				HStack {
					ForEach(0..<ToolbarButton.allCases.count) { index in
							Button(action: {
								buttonAction(index)
							}, label: {
								Image(systemName: "\(ToolbarButton.allCases[index].rawValue)")
										.resizable()
										.foregroundColor(.purple)
										.scaledToFit()
										.padding()
							}).padding()
						}
				}.foregroundColor(Color(UIColor.systemGray6))
					.frame(height: 100)
				
					TeamsView(match: match)
					MatchView(match: match)
					SetView(match: match)
					HStack {
						Spacer()
						Text(String(gameScore(.left)))
							.font(.system(size: 300, weight: .bold, design: .rounded))
							.minimumScaleFactor(0.25)
							.lineLimit(1)
							.scaledToFill()
						Spacer()
						GroupBox {
							Text("Match Status = \(String(describing: match.status)), Game Status = \(String(describing: match.game.status))")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.foregroundColor(.green)
								.padding()
						}.frame(width: match.middlePanelWidth * 1.5)
						Spacer()
						Text(String(gameScore(.right)))
							.font(.system(size: 300, weight: .bold, design: .rounded))
							.lineLimit(1)
							.minimumScaleFactor(0.25)
							.scaledToFill()
						Spacer()
					}
				Spacer()
				}
				/*ZStack {
					
					HStack {
						makeGroup(.left)
						Rectangle()
							.foregroundColor(.black)
							.frame(width: geo.size.width/9)
						makeGroup(.right)
					}
					VStack {
						PossessionArrow(match: match)
							.frame(width: geo.size.width/7, height: geo.size.height/8)
						
						HStack {
							SeriesScoreView(viewModel: leftMatchVM)
							Text("M A T C H")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: rightMatchVM)
							
						}.frame(height: geo.size.height/8)
						
						HStack {
							SeriesScoreView(viewModel: leftSetVM)
							Text("S E T")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: rightSetVM)
						}.frame(height: geo.size.height/8)
						
						Spacer(minLength: geo.size.height * 2/8)
						GroupBox {
							Text("Match Status = \(String(describing: match.status)), Game Status = \(String(describing: match.game.status))")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.foregroundColor(.green)
								.padding()
						}
						
						Spacer(minLength: geo.size.height/8)
					}
				}
				
			}*/
			
			.onAppear {
				match.geoSize = geo.size
			}
		}
	}
		/*
		return GeometryReader { geo in
			VStack {
				HStack {
					ForEach(0..<ToolbarButton.allCases.count) { index in
							Button(action: {
								buttonAction(index)
							}, label: {
								Image(systemName: "\(ToolbarButton.allCases[index].rawValue)")
										.resizable()
										.foregroundColor(.purple)
										.scaledToFit()
										.padding()
							}).padding()
						}
					
				}.foregroundColor(Color(UIColor.systemGray6))
					.frame(height: 100)
				
				
				ZStack {
					
					HStack {
						makeGroup(.left)
						Rectangle()
							.foregroundColor(.black)
							.frame(width: geo.size.width/9)
						makeGroup(.right)
					}
					VStack {
						PossessionArrow(match: match)
							.frame(width: geo.size.width/7, height: geo.size.height/8)
						
						HStack {
							SeriesScoreView(viewModel: leftMatchVM)
							Text("M A T C H")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: rightMatchVM)
							
						}.frame(height: geo.size.height/8)
						
						HStack {
							SeriesScoreView(viewModel: leftSetVM)
							Text("S E T")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: rightSetVM)
						}.frame(height: geo.size.height/8)
						
						Spacer(minLength: geo.size.height * 2/8)
						GroupBox {
							Text("Match Status = \(String(describing: match.status)), Game Status = \(String(describing: match.game.status))")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.foregroundColor(.green)
								.padding()
						}
						
						Spacer(minLength: geo.size.height/8)
					}
				}
				
			}
			
			.onAppear {
				match.geoSize = geo.size
			}
		}
	}*/
	
	func gameScore(_ tableSide: TableSide) -> Int {
		let id = match.teamID(tableSide)
		return id == .home ? match.game.home : match.game.guest
	}
	
	func makeGroup(_ tableSide: TableSide) -> some View {
		let id = match.teamID(tableSide)
		let score = id == .home ? match.game.home : match.game.guest
		return VStack {
			Spacer()
			Text(id.rawValue.uppercased())
				.font(.system(size: 100, weight: .semibold, design: .monospaced))
				.padding()
			Divider()
			
			Text(String(score))
				.font(.system(size: 700, weight: .bold, design: .rounded))
				.minimumScaleFactor(0.5)
				.padding([.leading, .trailing])
			Rectangle()
				.foregroundColor(Color(UIColor.systemGray6))
				.frame(height: 200)
				.layoutPriority(1)
			
		}.background(Color.black)
	}
	/*
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
	 }
	 .layoutPriority(1)
	 //.groupBoxStyle(BlackGroupBoxStyle())
	 }
	 
	 .navigationBarTitle("\(match.set.home.count) - \(match.set.guest.count)")
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
	func setScore(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return match.set.home.count
		case .guest:
			return match.set.guest.count
		}
	}
	
	func matchScore(_ tableSide: TableSide) -> Int {
		switch match.teamID(tableSide) {
		case .home:
			return match.homeSets.count
		case .guest:
			return match.guestSets.count
		}
	}

	var leftSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .left, currentScore: setScore(.left), winningScore: match.set.setType.pointGoal)
	}
	
	var rightSetVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .right, currentScore: setScore(.right), winningScore: match.set.setType.pointGoal)
	}
	
	var leftMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .left, currentScore: matchScore(.left), winningScore: match.matchType.pointGoal)
	}
	
	var rightMatchVM: SeriesScoreVM {
		SeriesScoreVM(tableSide: .right, currentScore: matchScore(.right), winningScore: match.matchType.pointGoal)
	}

	/*
	 func toolBarItemGroup() -> some ToolbarContent {
		 ToolbarItemGroup(placement: .navigationBarLeading) {
			 ForEach(0..<ToolbarButton.allCases.count) { index in
				 Button(action: {
					 buttonAction(index)
				 }, label: {
					 switch ToolbarButton.allCases[index] {
					 case .spacer, .spacer1, .spacer2:
						 Spacer()
					 default:
						 Image(systemName: "\(ToolbarButton.allCases[index].rawValue).circle")
							 .resizable()
							 .frame(width: 100, height: 100)
					 }
				 })
			 }
		 }
	 */

	
	
	func buttonAction(_ index: Int) {
		switch ToolbarButton.allCases[index] {
		case .settings:
			match.singleTapMiddle()
		case .plus:
			match.singleTap(.left)
		case .minus:
			match.singleTap(.right)
		case .play:
			match.doubleTap(.left)
		case .pause:
			match.doubleTap(.right)
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
	case play
	case pause
}
