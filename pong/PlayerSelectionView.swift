//
//  PlayerSelectionView.swift
//  PlayerSelectionView
//
//  Created by Charles Faquin on 9/17/21.
//

import SwiftUI

struct PlayerSelectionView: View {
	
	//let selectedPlayer: Player?
	@ObservedObject var viewModel: PlayerSelectionVM
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
    var body: some View {
			VStack {
						Button(action: createNewPlayer, label: { Label("New Player", systemImage: "plus") })
							.foregroundColor(.pink)
							.font(notMacApp ? .title3 : .title2)
							.cornerRadius(10)
							.border(Color.pink, width: 2)
					
				List {
					ForEach($list.notes) { $note in
							NavigationLink(
								note.title,
								destination:
									NoteEditView(
																note: $note
														)
												)
										}
				List {
					ForEach($viewModel.players) { $player in
						NavigationLink
					}
				}
				
			}
		}
	
	func createNewPlayer() {
		
	}

	// MARK: - Dynamic Content
	private var content: some View {
			switch viewModel.state {
			case .idle:
					return AnyView(EmptyView())
			case .loading:
					return AnyView(ProgressView())
			case .loaded(let names, let prefix):
					return AnyView(filteredListView(of: names.sorted(), prefix: prefix))
			case .error(let error):
					return AnyView(Text("Error: \(error.localizedDescription)"))
			}
	}
	
	/// Build a list view of contact names with filtered state.
	private func filteredListView(of contactNames: [String], prefix: String?) -> some View {
			let headerText: String = {
					if let prefix = prefix {
							return "Contacts starting with “\(prefix)”"
					} else {
							return "All Contacts"
					}
			}()

			return List {
					Section(header: Text(headerText)) {
							ForEach(contactNames) { name in
									Text(name)
							}
					}
			}.listStyle(GroupedListStyle())
	}
	
	/// View for adding a new Contact.
	private var addPlayerView: some View {
			
	}
}
	


struct PlayerRow: View {
	
	@State var image: Image = Image(systemName: "person.circle")
	let player: Player
	
	
	init(_ player: Player) {
		self.player = player
		player.loadAvatar { photo in
			image = photo ?? image
		}
	}
	
	var body: some View {
		HStack {
			image
				.imageScale(.large)
				.overlay(
					Circle()
						.strokeBorder(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
						.foregroundColor(.pink)
				)
				.padding()
			VStack {
				Text(player.username)
					.font(.headline)
				Text("\(player.firstName) \(player.lastName)")
					.font(.subheadline)
			}
			Text("")
		}
	}
}
	
	

struct PlayerSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerSelectionView(viewModel: PlayerSelectionVM())
    }
}
