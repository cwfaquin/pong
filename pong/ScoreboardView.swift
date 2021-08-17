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
			VStack {
				HStack {
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
									.foregroundColor(.purple)
							}
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
							SeriesScoreView(viewModel: homeMatchVM)
							Text("M A T C H")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: guestMatchVM)
							
						}.frame(height: geo.size.height/8)
						
						HStack {
							SeriesScoreView(viewModel: homeSetVM)
							Text("S E T")
								.font(.system(size: 50, weight: .ultraLight, design: .rounded))
								.frame(width: geo.size.width/9)
							SeriesScoreView(viewModel: guestSetVM)
						}.frame(height: geo.size.height/8)
						
						Spacer(minLength: geo.size.height * 2/8)
						GroupBox {
							Text("Update the status here.")
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
			
			
			
		}
		
		func makeGroup(_ tableSide: TableSide) -> some View {
			let id = match.teamID(tableSide)
			let score = id == .home ? 20 : 20
			return VStack {
				Spacer()
				Text(id.rawValue.uppercased())
					.font(.system(size: 100, weight: .semibold, design: .monospaced))
					.padding()
				Divider()
				
				Text(String(score))
					.font(.system(size: 700, weight: .bold, design: .rounded))
					.minimumScaleFactor(0.9)
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
