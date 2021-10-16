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
	let teamID: TeamID
	@State var editingPlayer: Player?
	@State var showAddNewPlayer = false
	@State var editingMode = false
	@Environment(\.presentationMode) private var presentationMode
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		
		NavigationView {

			List(selection: $selectedPlayer) {
				NavigationLink(destination: editPlayerView(nil), tag: .newPlayer, selection: $editingPlayer) { EmptyView() }

				listContent
				
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) { newPlayerButton }
				ToolbarItem(placement: .navigationBarLeading) { closeButton }
			}
			.navigationBarTitle("\(teamID.rawValue.capitalized) Team")
			
		}
		.accentColor(.pink)
		.navigationViewStyle(StackNavigationViewStyle())
		.onAppear {
			viewModel.fetchPlayers()
		}
		.onChange(of: selectedPlayer) { selected in
			guard selected != nil else { return }
			presentationMode.wrappedValue.dismiss()
		}
	}
	
	var newPlayerButton: some View {
		Button(action: { editingPlayer = .newPlayer }) {
			HStack {
				Image(systemName: "plus.circle")
					.imageScale(.large)
					.foregroundColor(.pink)
				Text("New Player")
					.font(.title3)
					.foregroundColor(.pink)
			}
		}
	}
	
	var closeButton: some View {
		Button(action: { presentationMode.wrappedValue.dismiss() }) {
			Image(systemName: "xmark")
				.resizable()
				.foregroundColor(.pink)
		}
	}
	
	var playerRows: some View {
		ForEach(viewModel.players, id: \.id) { player in
			HStack {
				playerRow(player)
				if editingMode {
					NavigationLink(destination: editPlayerView(player), tag: player, selection: $editingPlayer) { EmptyView() }
				}
			}
			.listRowBackground(player == selectedPlayer ? Color.black : Color.clear)
		}
		.onDelete(perform: viewModel.deletePlayers)
	}
	
	var listContent: some View {
		Section(header:
							HStack {
			Text(editingMode ? "Edit Player" : "Select Player")
				.padding()
			Spacer()
			Toggle("", isOn: $editingMode)
			Text("Edit")
				.padding(.leading)
		}
		) {
			switch viewModel.state {
			case .loading:
				loadingView
			case .noResults:
				Text("No Players Found")
					.font(.title)
					.bold()
					.padding()
			case .results:
				playerRows
			}
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
		PlayerRow(
			player: player,
			selectedPlayer: $selectedPlayer,
			selectionDisabled: $editingMode
		)
	}
}

struct PlayerRow: View {
	
	@State var avatar: UIImage?
	@State var player: Player
	@Binding var selectedPlayer: Player?
	@Binding var selectionDisabled: Bool
	
	var isSelected: Bool {
		player == selectedPlayer
	}
	
	var body: some View {
		HStack {
			image
			Text(player.username)
				.font(.title)
				.foregroundColor(.white)
			Spacer()
		}
		.onAppear {
			updateAvatar()
		}
		.onTapGesture {
			guard !selectionDisabled else { return }
			selectedPlayer = selectedPlayer == player ? nil : player
		}
		
		.onChange(of: player) { newValue in
			updateAvatar()
		}
	}
	
	func updateAvatar() {
		avatar = nil
		player.loadAvatar { image in
			guard let image = image else { return }
			avatar = image
		}
	}
	
	var image: some View {
		let image: Image
		if let avatar = avatar {
			image = Image(uiImage: avatar)
		} else {
			image = Image(systemName: "person.circle")
		}
		return image
			.resizable()
			.frame(width: 50, height: 50)
			.foregroundColor(.blue)
			.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
			.padding()
	}
	
	
	
	
}



struct PlayerSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerSelectionView(selectedPlayer: .constant(nil), teamID: .home)
	}
}
