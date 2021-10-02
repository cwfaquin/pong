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
						Text("\(settings.gameType.pointGoal) Points to Win (+2pt Advantage)")
							.fontWeight(.light)
							.padding(.trailing)
							.foregroundColor(.gray)
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
						Text("\(settings.setType.pointGoal) Game(s) to Win")
							.fontWeight(.light)
							.padding(.trailing)
							.foregroundColor(.gray)
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
						Text("\(settings.matchType.pointGoal) Set(s) to Win")
							.fontWeight(.light)
							.padding(.trailing)
							.foregroundColor(.gray)
					}
					Picker("Match Length", selection: $settings.matchType) {
						ForEach(MatchType.allCases) { type in
							Text(type.description).tag(type)
						}
					}.pickerStyle(SegmentedPickerStyle())
				}.padding(.top  )
			}
		
				Section(header: Text("Flic Buttons".spaced)) {
					if Storage.isMacApp {
						Text("Only available on iOS devices.")
					} else {
					HStack {
						Text("Buttons Found:")
							.foregroundColor(.white.opacity(0.9))
						Text("\(buttonManager.buttonsFound.count)")
							.bold()
						Spacer()
						Text(buttonManager.scanStatus)
						Spacer()
						if buttonManager.isScanning {
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
									.foregroundColor(Color(UIColor.cyan))
							})
						}
					}
						ForEach(buttonManager.buttonsFound, id: \.identifier) { button in
							if let pongName = button.pongName {
								namedButtonView(button, name: pongName)
							} else {
								unnamedButtonView(button)
							}
						}
					}
				}
			}
		.onAppear {
			buttonManager.updateButtons()
		}
		.cornerRadius(10)
		.padding()
	}
	
	func namedButtonView(_ button: FLICButton, name: FlicName) -> some View {
			HStack {
				Button(
					action: {
						button.nickname = nil
						buttonManager.updateButtons()
					},
					label: {
						Image(systemName: "\(name.imageName).fill")
							.resizable()
							.foregroundColor(button.isReady ? .green : .orange)
							.frame(width: 40, height: 40)
					}
				)
				buttonNameView(button.uuid)
				rightButtonView(button)
			}
			.padding(.vertical)
	}
	
	func unnamedButtonView(_ button: FLICButton) -> some View {
		HStack {
			HStack(alignment: .center, spacing: 15) {
			ForEach(FlicName.allCases, id: \.rawValue) { name in
				Button(
					action: {
						button.nickname = name.rawValue
						buttonManager.updateButtons()
					},
					label: {
						Image(systemName: name.imageName)
							.resizable()
							.foregroundColor(Color(UIColor.cyan))
							.frame(width: 40, height: 40)
					})
			}
			}
			buttonNameView(button.uuid)
			rightButtonView(button)
		}
		.padding(.vertical)
	}
	
	func buttonNameView(_ name: String) -> some View {
		VStack(alignment: .center, spacing: 10) {
			Text("Button ID:")
				.underline()
			Text(name)
				.font(.caption)
		}
		.padding(.horizontal)
	}

	func rightButtonView(_ button: FLICButton) -> some View {
		HStack {
			Text(buttonManager.statusFor(button))
				.multilineTextAlignment(.center)
				.lineLimit(0)
				.padding(.horizontal)
			Spacer()
			switch button.state {
			case .connected:
				Button(action: { button.disconnect() }) {
					Text("Disconnect")
						.foregroundColor(.pink)
				}
			case .disconnected:
				Button(action: { button.connect() }) {
					Text("Connect")
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
