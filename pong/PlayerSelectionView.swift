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
	@State var editMode: EditMode = .inactive
	@Environment(\.presentationMode) private var presentationMode

	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		
		NavigationView {
			List {
				Section {
					NavigationLink(destination: editPlayerView(nil)) {
						PlayerRow(player: nil)
					}
				}
				Section(header: Text("Select Player")) {
					if viewModel.isLoading {
						loadingView
					} else if viewModel.players.isEmpty {
						Text("No Players Found")
							.font(.title)
							.bold()
							.padding()
					} else {
						ForEach(viewModel.players, id: \.id) { player in
							switch editMode {
							case .active:
								NavigationLink(destination: editPlayerView(player)) {
									playerRow(player)
								}
							default:
								playerRow(player)
							}
						}
						.onDelete(perform: viewModel.deletePlayers)
						.listItemTint(.pink)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: { selectedPlayer = selectedPlayer }) {
						Image(systemName: "xmark")
							.resizable()
							.foregroundColor(.pink)
					}
				}
			}
			.navigationBarTitle("Home Team")
			.environment(\.editMode, $editMode)
			.accentColor(.pink)
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onAppear {
			viewModel.fetchPlayers()
		}
	}
	
	func editPlayerView(_ player: Player?) -> some View {
			EditPlayerView(
				player: player ?? .newPlayer,
				newPlayer: player == nil,
				showPinPrompt: player != nil && player?.pinRequired == true
			).environmentObject(viewModel)
	}

	var loadingView: some View {
		ZStack {
			Rectangle()
				.foregroundColor(.black.opacity(0.9))
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle())
		}
	}
	
	func playerRow(_ player: Player) -> some View {
		PlayerRow(player: player)
			.border(Color.blue, width: selectedPlayer == player ? 2 : 0)
			.cornerRadius(selectedPlayer == player ? 8 : 0)
			.background(selectedPlayer == player ? Color.black : nil)
			.onTapGesture {
					 print("Shit")
					 guard editMode != .active else { return }
					 withAnimation {
						 selectedPlayer = player
					 }
				 }
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
