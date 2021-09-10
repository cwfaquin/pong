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
	@Binding var settings: MatchSettings
	@Binding var showSettings: Bool

	
	var flicButtonCount: Int {
		FLICManager.shared()?.buttons().count ?? 1
	}
	
	var body: some View {
		VStack {
			Button("Dismsiss", action: { showSettings.toggle() })
				.buttonStyle(RoundedRectangleButtonStyle())
				.padding()
			
		Form {
			Section(header: Text("Preferences".spaced)) {
				Toggle(isOn: $settings.showControlButtons) {
					Text("Always Show Scoreboard Buttons")
				}
				Toggle(isOn: $settings.recordMatchResults) {
					Text("Report Match Results")
				}.disabled(true)
			}
			
			Section(header: Text("Match Settings".spaced)) {
					VStack(alignment: .leading) {
							Text("Game Length")
						Picker("Game Length", selection: $settings.gameType) {
								ForEach(GameType.allCases) { type in
									Text(type.description).tag(type)
								}
							}.pickerStyle(SegmentedPickerStyle())
					}.padding(.top)
				
				VStack(alignment: .leading) {
						Text("Set Length (games)")
					Picker("Set Length", selection: $settings.setType) {
							ForEach(SetType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
				}.padding(.top)
				
				VStack(alignment: .leading) {
						Text("Match Length (sets)")
					Picker("Match Length", selection: $settings.matchType) {
							ForEach(MatchType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
				}.padding(.top  )
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
		}.padding([.top, .bottom])
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
		SettingsView(viewModel: SettingsVM(), settings: .constant(MatchSettings()), showSettings: .constant(true))
	}
}
