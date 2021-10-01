//
//  PlayerSelectionView.swift
//  PlayerSelectionView
//
//  Created by Charles Faquin on 9/17/21.
//

import SwiftUI
import CloudKit

struct PlayerSelectionView: View {
	@StateObject var viewModel = PlayerSelectionVM()
	@Binding var selectedPlayer: Player?
	@State var editingPlayer: Player?
	@State var showAddNewPlayer: Bool = false
	@State var editMode: EditMode = .active
	@Environment(\.presentationMode) private var presentationMode

	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		
		NavigationView {
			ZStack {
				if !viewModel.isLoading, viewModel.players.isEmpty {
					Text("No Players Found")
						.font(.title)
						.bold()
						.padding()
				} else {
					List(selection: $selectedPlayer) {
						Section {
						NavigationLink(destination:
														EditPlayerView(player: newPlayer, savedPlayer: $selectedPlayer)
															.environmentObject(viewModel),
													 isActive: .init(
														get: { showAddNewPlayer },
														set: {_ in
															showAddNewPlayer = selectedPlayer != nil
														}
													 )
						) {
							PlayerRow(player: nil)
						}
						}
						Section(header: Text("Select Player")) {
							ForEach(viewModel.players, id: \.id) { player in
								PlayerRow(player: player)
									.border(Color.blue, width: selectedPlayer == player ? 2 : 0)
									.cornerRadius(selectedPlayer == player ? 8 : 0)
									.background(selectedPlayer == player ? Color.black : nil)
							}
						}
					}
					.environment(\.editMode, $editMode)
				
				}
				if viewModel.isLoading {
					ZStack {
						Rectangle()
							.foregroundColor(.black.opacity(0.9))
						ProgressView()
							//.progressViewStyle(.circular)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink(destination:
													EditPlayerView(player: newPlayer, savedPlayer: $selectedPlayer)
													.environmentObject(viewModel),
												 isActive: $showAddNewPlayer
					) {
						Image(systemName: "plus")
							.resizable()
							.foregroundColor(.pink)
					}
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: { selectedPlayer = selectedPlayer }) {
						Image(systemName: "xmark")
							.resizable()
							.foregroundColor(.pink)
					}
				}
			}

			.navigationTitle("Home Player")
		}
		.accentColor(.pink)
		.onAppear {
			viewModel.fetchPlayers()
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onChange(of: viewModel.selectedPlayer) { newValue in
			selectedPlayer = newValue
		}
	}
	
	
	var newPlayer: Player {
		Player(record: CKRecord(recordType: Player.recordType))
	}
}



struct PlayerRow: View {
	
	@State var avatar: UIImage?
	@State var player: Player?

	var isNew: Bool {
		player == nil
	}
	
	var body: some View {
		HStack {
			if isNew { Spacer() }
			image
			Text(player?.username ?? "New Player")
				.font(.title)
				.foregroundColor(isNew ? .pink : .white)
			Spacer()
			
		}
		.onAppear {
			player?.loadAvatar { image in
				avatar = image
			}
		}
		.navigationTitle(player?.username ?? "New Player")
	}
	
	var image: some View {
		let image: Image
		if let avatar = avatar {
			image = Image(uiImage: avatar)
		} else {
			image = isNew ? Image(systemName: "plus") : Image(systemName: "person.circle")
		}
		return image
			.resizable()
			.frame(width: isNew ? 30 : 40, height: isNew ? 30 : 40)
			.foregroundColor(player == nil ? .pink : .blue)
			.padding()
	}
}



struct PlayerSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerSelectionView(selectedPlayer: .constant(nil), editingPlayer: nil)
	}
}
