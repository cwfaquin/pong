//
//  EditPlayerView.swift
//  EditPlayerView
//
//  Created by Charles Faquin on 9/18/21.
//

import SwiftUI
import CloudKit

struct EditPlayerView: View {
	
	@Environment(\.presentationMode) private var presentationMode
	@EnvironmentObject var viewModel: PlayerSelectionVM
	@State var confirmPin = ""
	@State var alertMessage = ""
	@State var validationError = false
	@State var player: Player
	@State var newPlayer: Bool
	@State var showPinPrompt: Bool

	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		ZStack {
		
		Form {
			HStack {
				if newPlayer {
				GroupBox {
					Button(action: showContacts, label: { Label("Autofill Contact", systemImage: "plus.circle") })
						.foregroundColor(.pink)
						.font(notMacApp ? .title3 : .title2)
						.lineLimit(1)
				}
				.cornerRadius(10)
				.groupBoxStyle(BlackGroupBoxStyle(color: Color(UIColor.systemGray6)))
				}
				Spacer()
				
				Text("Required *")
					.foregroundColor(.gray)
					.italic()
					.padding(4)
					.background(Color.black)
					.cornerRadius(8)
					.padding(.vertical)
			}
			
			TextField("First Name *", text: $player.firstName)
				.textContentType(.givenName)
				.font(.headline)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding(.vertical)
			
			TextField("Last Name *", text: $player.lastName)
				.textContentType(.familyName)
				.font(.headline)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding(.vertical)
			
			TextField("Username", text: $player.username)
				.textContentType(.username)
				.font(.headline)
				.accentColor(.pink)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.padding(.vertical)
			
			HStack {
				Toggle("Require PIN", isOn: $player.pinRequired)
					.accentColor(.pink)
				Spacer()
				if newPlayer {
					Divider()
						.padding()
					SecureField("4 Digit PIN *", text: $player.pin)
						.multilineTextAlignment(.center)
						.font(.headline)
						.keyboardType(.numberPad)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding(.vertical)

					SecureField("Re-enter PIN *", text: $confirmPin)
						.font(.headline)
						.multilineTextAlignment(.center)
						.keyboardType(.numberPad)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding(.vertical)
						.accentColor(.pink)

				}
			}
			
		}
		.accentColor(.pink)

			if showPinPrompt {
				pinPromptView
			}
		}
		.navigationBarItems(trailing:
				Button("Save", action: { save() })
						.foregroundColor(.pink)
		)
		.alert(isPresented: $validationError) {
			Alert(
				title: Text("Invalid Entry"),
				message: Text(alertMessage),
				dismissButton: .default(Text("Gotcha"))
			)
		}
		.onChange(of: confirmPin) { newValue in
			if showPinPrompt {
				showPinPrompt = newValue.trimmingCharacters(in: .whitespacesAndNewlines) == player.pin
			}
		}
		
	}
	
	var pinPromptView: some View {
		ZStack {
			Rectangle()
				.foregroundColor(.black.opacity(0.9))
			
			HStack {
				Spacer()
			
				SecureField("4 Digit PIN", text: $confirmPin)
				.multilineTextAlignment(.center)
				.keyboardType(.numberPad)
				.textContentType(.newPassword)
				.font(.headline)
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.border(Color.pink, width: 1)
				.cornerRadius(8)
				
				Spacer()
			}
				
		}
	}
	
	func save() {
		guard !player.firstName.isEmpty else {
			alertMessage = "First Name cannot be empty."
			validationError = true
			return
		}
		guard !player.lastName.isEmpty else {
			alertMessage = "Last Name cannot be empty."
			validationError = true
			return
		}
		if player.username.isEmpty {
			player.username = "\(player.firstName) \(player.lastName)"
		}
		if newPlayer {
			player.pin = player.pin.trimmingCharacters(in: .whitespacesAndNewlines)
			guard player.pin.isValidPIN else {
				alertMessage = "PIN must be exactly 4 numbers."
				validationError = true
				return
			}
			guard player.pin == confirmPin else {
				alertMessage = "PIN entries do not match."
				validationError = true
				return
			}
		}
		viewModel.savePlayer(player.makePlayerRecord(), at: nil)
	}

	
	func showContacts() {
		
	}
}

struct EditPlayerView_Previews: PreviewProvider {
	static var previews: some View {
		EditPlayerView(player: .newPlayer, newPlayer: true, showPinPrompt: false)
			.environmentObject(PlayerSelectionVM())
	}
}
