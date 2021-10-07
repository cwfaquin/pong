//
//  SettingsView.swift
//  SettingsView
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI
import flic2lib

struct SettingsView: View {
	@Binding var settings: MatchSettings
	@Binding var showSettings: Bool
	
	var body: some View {
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
					}
					.pickerStyle(SegmentedPickerStyle())
				}
				.padding(.top)
			}
		
			Button("Dismsiss", action: { showSettings.toggle() })
				.buttonStyle(RoundedRectangleButtonStyle())
				.padding()
			}
		.cornerRadius(10)
		.padding()
	}

	
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(settings: .constant(MatchSettings()), showSettings: .constant(true))
	}
}
