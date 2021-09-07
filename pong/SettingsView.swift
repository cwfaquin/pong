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
	@Binding var showControlButtons: Bool
	
	var flicButtonCount: Int {
		FLICManager.shared()?.buttons().count ?? 1
	}
	
	var body: some View {
		VStack {
			Button(
				action: { showSettings.toggle() },
				label: {
					Text("O K").bold()
					.foregroundColor(.pink)
					.padding()
				}
			)
			.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(.pink, lineWidth: 1)
			)
			.padding()
			
		Form {
			Section(header: Text("Match Settings".spaced).bold()) {
					VStack(alignment: .leading) {
							Text("Game Length")
							Picker("Game Length", selection: $gameType) {
								ForEach(GameType.allCases) { type in
									Text(type.description).tag(type)
								}
							}.pickerStyle(SegmentedPickerStyle())
					}
				
				VStack(alignment: .leading) {
						Text("Set Length")
						Picker("Set Length", selection: $setType) {
							ForEach(SetType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
				}
				
				VStack(alignment: .leading) {
						Text("Match Length").bold()
						Picker("Match Length", selection: $matchType) {
							ForEach(MatchType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
				}
			}
			
			Section {
				Toggle(isOn: $showControlButtons) {
					Text("Always Show Scoreboard Buttons")
				}
			}
				
			if viewModel.flicConnectable {
				Section(header: HStack {
					Text("Flic Buttons".spaced)
					Spacer()
					if viewModel.needsScan {
						Button(action: viewModel.scanForButtons, label: {
							Text("Scan")
								.padding(.trailing)
						})
					}
				}) {
					ForEach(FlicName.allCases, id: \.rawValue) { name in
						flicView(name)
					}
				}
			}
		}
		}
		.cornerRadius(10)
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
		SettingsView(viewModel: SettingsVM(), gameType: .constant(.long), setType: .constant(.bestOfThree), matchType: .constant(.bestOfFive), showSettings: .constant(true), showControlButtons: .constant(true))
	}
}
