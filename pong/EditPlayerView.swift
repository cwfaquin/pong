//
//  EditPlayerView.swift
//  EditPlayerView
//
//  Created by Charles Faquin on 9/18/21.
//

import SwiftUI
import CloudKit

struct EditPlayerView: View {
	
	@EnvironmentObject var viewModel: PlayerSelectionVM
	@Binding var isPresented: Bool
	
	@State var confirmPin = ""
	@State var alertMessage = ""
	@State var validationError = false
	@State var player: Player
	@State var newPlayer: Bool
	@State var avatarImage: UIImage?
	
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		ZStack {
			
			Form {
				if newPlayer {
					Button(action: showContacts, label: {
						Label("Autofill Contact", systemImage: "plus.circle")
							.font(.title3)
					})
						.foregroundColor(.blue)
				}
				HStack {
					Text("Avatar: ")
						.font(.title2)
						.padding()
					avatarView
					Spacer()
				}
				
				if newPlayer {
					TextField("First Name", text: $player.firstName)
						.textContentType(.givenName)
						.font(.headline)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding()
					
					TextField("Last Name", text: $player.lastName)
						.textContentType(.familyName)
						.font(.headline)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.padding()
				}
		
				
				VStack(alignment: .leading) {
						if !newPlayer {
						Text("Edit Username")
						}
						TextField("Username", text: $player.username)
							.textContentType(.username)
							.font(.headline)
							.accentColor(.pink)
							.textFieldStyle(RoundedBorderTextFieldStyle())
						
					
				}.padding()
				
				
				HStack {
					Toggle("Require PIN", isOn: $player.pinRequired)
						.accentColor(.pink)
					Spacer()
						Divider()
							.padding()
						SecureField("4 Digit PIN", text: $player.pin)
							.multilineTextAlignment(.center)
							.font(.headline)
							.keyboardType(.numberPad)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding(.vertical)
						
						SecureField("Re-Enter PIN", text: $confirmPin)
							.font(.headline)
							.multilineTextAlignment(.center)
							.keyboardType(.numberPad)
							.textFieldStyle(RoundedBorderTextFieldStyle())
							.padding(.vertical)
							.accentColor(.pink)
				}
				
			}
			.accentColor(.pink)
			
		}
		.navigationTitle(newPlayer ? "New Player" : "\(player.firstName) \(player.lastName)")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Save", action: { save() })
				.font(.title2)
				.foregroundColor(.pink)
			}
		}
		.alert(isPresented: $validationError) {
			Alert(
				title: Text("Invalid Entry"),
				message: Text(alertMessage),
				dismissButton: .default(Text("Gotcha"))
			)
		}
	}

	
	func save() {

		guard !player.username.isEmpty else {
			alertMessage = "Username cannot be empty."
			validationError = true
			return
		}
		
		if newPlayer {
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
	
	
	var avatarView: some View {
		ZStack {
			if let avatarImage = avatarImage {
				Image(uiImage: avatarImage)
					.resizable()
					.aspectRatio(nil, contentMode: .fit)
			} else {
				Image(systemName: "person.crop.circle.badge.plus")
					.resizable()
					.foregroundColor(.blue)
					.aspectRatio(nil, contentMode: .fit)
			}
			Button(action: addImage) {
				Image(uiImage: UIImage())
					.resizable()
			}
		}
		.frame(width: 120)
		.padding()
	}
	
	
	func addImage() {
		
	}
	
	func showContacts() {
		
	}
	
	func loadAvatar() {
		guard player.avatar != nil else { return }
		player.loadAvatar { photo in
			DispatchQueue.main.async {
				avatarImage = photo
			}
		}
	}
}

struct EditPlayerView_Previews: PreviewProvider {
	static var previews: some View {
		EditPlayerView(isPresented: .constant(true), player: .newPlayer, newPlayer: true)
			.environmentObject(PlayerSelectionVM())
	}
}
