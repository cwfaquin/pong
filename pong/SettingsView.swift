//
//  SettingsView.swift
//  SettingsView
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI
import flic2lib

struct SettingsView: View {
	
	@ObservedObject var viewModel: SettingsVM
	@Binding var gameType: GameType
	@Binding var setType: SetType
	@Binding var matchType: MatchType
	@Binding var showSettings: Bool
	
	var flicButtonCount: Int {
		FLICManager.shared()?.buttons().count ?? 1
	}
	
	var body: some View {
		NavigationView {
		Form {
			Section(header: Text("Points")) {
				HStack {
					ForEach(GameType.allCases, id: \.rawValue) { type in
						GroupBox {
							Button(
								action: { gameType = type },
								label: {
									Text("\(type.pointGoal)")
										.padding()
								}
							).lineLimit(1)
								.cornerRadius(10)
								.foregroundColor(gameType == type ? Color.pink : Color.white)
								.font(.largeTitle)
						}
					}
				}
			}.font(.largeTitle)
			
			Section(header: Text("Games")) {
				HStack {
					ForEach(SetType.allCases, id: \.rawValue) { type in
						GroupBox {
							Button(
								action: { setType = type },
								label: {
									Text("\(type.pointGoal)")
										.padding()
								}
							).lineLimit(1)
								.cornerRadius(10)
								.foregroundColor(setType == type ? Color.pink : Color.white)
							//	.background(gameType == type ? Color.pink : Color.clear)
								.font(.title)
						}
					}
				}
			}.font(.largeTitle)
		
		Section(header: Text("Sets")) {
			HStack {
				ForEach(MatchType.allCases, id: \.rawValue) { type in
					GroupBox {
						Button(
							action: { matchType = type },
							label: {
								Text("\(type.pointGoal)")
									.padding()
							}
						).lineLimit(1)
							.cornerRadius(10)
							.foregroundColor(matchType == type ? Color.pink : Color.white)
						//	.background(gameType == type ? Color.pink : Color.clear)
							.font(.title)
					}
				}
				
			}
			
		}.font(.largeTitle)
		
			Section(header: HStack {
				Text("Flic Buttons")
				Spacer()
				if viewModel.needsScan {
					Button(action: viewModel.scanForButtons, label: { Text("Scan") })
				}
			}) {
				ForEach(FlicName.allCases, id: \.rawValue) { name in
					flicView(name)
				}
			}
		}
		.navigationBarTitle("Settings")
		.navigationBarItems(
			trailing:
				Button(
					action: { showSettings = false },
					label: {
						Image(systemName: "xmark.circle")
							.resizable()
							.foregroundColor(Color.pink)
							.frame(width: 40, height: 40)
							.padding([.top, .trailing])
					}
				)
		)
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.cornerRadius(15)
	}
	
	func flicView(_ name: FlicName) -> some View {
		GroupBox(label: Label(name.rawValue, systemImage: "square"), content: {
			if let button = viewModel.flicButton(name) {
				HStack {
					VStack {
						Text("\(button.name ?? button.identifier.uuidString)")
						Text(button.state.description)
					}
					Spacer()
				switch button.state {
				case .connected:
					Button(action: { button.disconnect() }) {
						Text("Disconnect")
					}
				case .connecting, .disconnecting:
					ProgressView()
						.progressViewStyle(.circular)
				case .disconnected:
					Button(action: { button.connect() }) {
						Text("Disconnect")
					}
				default:
					Text("?")
				}
				}
			}
		})
	}
	

}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(viewModel: SettingsVM(), gameType: .constant(.long), setType: .constant(.bestOfThree), matchType: .constant(.bestOfFive), showSettings: .constant(true))
	}
}
