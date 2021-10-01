//
//  SettingsView.swift
//  SettingsView
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI
import flic2lib

struct SettingsView: View {
	@EnvironmentObject var buttonManager: ButtonManager
	@Binding var settings: MatchSettings
	@Binding var showSettings: Bool
	
	
	var flicButtonCount: Int {
		FLICManager.shared()?.buttons().count ?? 1
	}
	
	var body: some View {
			Form {
				Button("Dismsiss", action: { showSettings.toggle() })
					.buttonStyle(RoundedRectangleButtonStyle())
					.padding()
				
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
						HStack {
							Text("Game Length")
							Spacer()
							Text("\(settings.gameType.pointGoal)pts & 2pt advantage to win game")
								.fontWeight(.ultraLight)
								.padding(.trailing)
						}
						Picker("Game Length", selection: $settings.gameType) {
							ForEach(GameType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
					}.padding(.top)
					
					VStack(alignment: .leading) {
						HStack {
							Text("Set Length")
							Spacer()
							Text("\(settings.setType.pointGoal) games to win set")
								.fontWeight(.ultraLight)
								.padding(.trailing)
						}
						Picker("Set Length", selection: $settings.setType) {
							ForEach(SetType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
					}.padding(.top)
					
					VStack(alignment: .leading) {
						HStack {
							Text("Match Length")
							Spacer()
							Text("\(settings.matchType.pointGoal) sets to win")
								.fontWeight(.ultraLight)
								.padding(.trailing)
						}
						Picker("Match Length", selection: $settings.matchType) {
							ForEach(MatchType.allCases) { type in
								Text(type.description).tag(type)
							}
						}.pickerStyle(SegmentedPickerStyle())
					}.padding(.top  )
				}
				
				if !Storage.isMacApp {
					Section(header:
										HStack {
						Text("Flic Buttons".spaced)
						Spacer()
						if buttonManager.isScanning {
							Text(buttonManager.scanStatus)
								.italic()
							ProgressView()
								.progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.cyan)))
						} else {
							Button(action: {
								if buttonManager.allButtonsFound {
									buttonManager.forgetAllButtons()
								} else {
									buttonManager.scanForButtons()
								}
							}, label: {
								Text(buttonManager.allButtonsFound ? "Forget All" : "Scan")
									.padding(.trailing)
							})
						}
					})
					{
						ForEach(buttonManager.buttonsFound, id: \.identifier) { button in
							buttonView(button)
						}
					}
				}
			}
			.cornerRadius(10)
			.padding()
	}
	
	func buttonView(_ button: FLICButton) -> some View {
		HStack {
			if let pongName = button.pongName {
				Text(pongName.rawValue)
					.padding()
			} else {
				VStack {
					Text(button.nickname ?? button.uuid)
					Text(button.nickname == nil ? button.uuid : button.bluetoothAddress)
				}
				ForEach(FlicName.allCases, id: \.rawValue) { name in
					Button(action: { button.nickname = name.rawValue }, label: { Text(name.rawValue) })
				}
			}
			Spacer()
			Text(button.state.description)
				.foregroundColor(button.state.color)
				.fontWeight(.ultraLight)
			Spacer()
			switch button.state {
			case .connected:
				Button(action: { button.disconnect() }) {
					Text("Disconnect")
						.foregroundColor(.pink)
				}
			case .disconnected:
				Button(action: { button.connect() }) {
					Text("Disconnect")
						.foregroundColor(Color(UIColor.cyan))
				}
			default:
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
			}
		}
	}
	
	
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(settings: .constant(MatchSettings()), showSettings: .constant(true))
	}
}
