//
//  EditPlayerView.swift
//  EditPlayerView
//
//  Created by Charles Faquin on 9/18/21.
//

import SwiftUI
import CloudKit

struct EditPlayerView: View {
	
	@Binding var player: Player

	
    var body: some View {
			NavigationView {
					VStack {
						TextField("Username", text: $player.username)
									.font(.body)
									.textContentType(.name)
									.padding(.horizontal, 16)
						TextField("First Name", text: $player.firstName  )
								.textContentType(.givenName)
								.font(.headline)
								.textFieldStyle(RoundedBorderTextFieldStyle())
								.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
								.padding()
							Spacer()
					}
					.navigationTitle(player.username == nil ? "New Player" : "Edit \(player.username ?? "Player")")
					.navigationBarItems(leading: Button("Cancel", action: { print("pop") }),
															trailing: Button("Save", action: { print("save") })
															)
    }
}

struct EditPlayerView_Previews: PreviewProvider {
    static var previews: some View {
			EditPlayerView(player: .constant(Player(record: CKRecord(recordType: Player.recordType))))
    }
}
