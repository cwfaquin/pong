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

	var flicButtonCount: Int {
		FLICManager.shared()?.buttons().count ?? 1
	}
	
    var body: some View {
			Form {
				Section(header: Label("GAME", systemImage: "circle")) {
					HStack {
						ForEach(GameType.allCases, id: \.rawValue) { type in
							GroupBox {
							Button(
								action: { gameType = type },
								label: { Text("\(type.pointGoal) points") }
							)
								.cornerRadius(10)
								.foregroundColor(gameType == type ? Color.pink : Color.white)
							//	.background(gameType == type ? Color.pink : Color.clear)
								.font(.largeTitle)
						}
					}
				}
				}
				
				Section(header: Label("SET", systemImage: "circle")) {
					ForEach(SetType.allCases, id: \.rawValue) { type in
						switch type {
						case .singleGame:
							Text("Single Game")
						default:
							Text("Best of \(type.bestOf)")
						}
					}
				}
				
				Section(header: Label("MATCH", systemImage: "circle")) {
					ForEach(MatchType.allCases, id: \.rawValue) { type in
						switch type {
						case .singleSet:
							Text("Single Set")
						default:
							Text("Best of \(type.bestOf)")
						}
					}
				}
				
				Section(header: Label("Flic Buttons", image: "dot.radiowaves.left.and.right")) {
					ForEach(0..<flicButtonCount) { i in
						HStack {
							Text("Button \(i)")
							ProgressView()
								.progressViewStyle(.circular)
								
						}
					}
				}
			}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
			SettingsView(viewModel: SettingsVM(), gameType: .constant(.long), setType: .constant(.bestOfThree), matchType: .constant(.bestOfFive))
    }
}
