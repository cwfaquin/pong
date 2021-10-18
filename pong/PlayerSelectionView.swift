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
	@State var showEditor = false
	@State var deletePlayer: Player?
	@State var editingMode = false
	@State var pinPrompt = false
	@Environment(\.presentationMode) private var presentationMode
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		NavigationView {
			VStack {
				header
				switch viewModel.state {
				case .loading:
					loadingView
				case .noResults:
					Text("No Players Found")
						.font(.title)
						.bold()
						.padding()
				case .results:
					List {
						ForEach(viewModel.players, id: \.self) { player in
							playerRow(player)      
							.listRowBackground(player == selectedPlayer ? Color.black : Color.clear)
						}
					}
			}
			}
			
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					NavigationLink(
						destination: editPlayerView(nil),
						label: { HStack(alignment: .center) { Image(systemName: "plus.circle"); Text("New Player") }}
					)
				}
				ToolbarItem(placement: .navigationBarLeading) { closeButton }
			}
			.navigationBarTitle("\(teamID.rawValue.capitalized) Team")
		}
		
		.navigationViewStyle(StackNavigationViewStyle())
		
		
		
		.accentColor(.pink)
		
		.onAppear {
			viewModel.fetchPlayers()
		}
		.onChange(of: selectedPlayer) { selected in
			guard selected != nil else { return }
			presentationMode.wrappedValue.dismiss()
		}
	}
	
	func pinOverlay(deletePlayer: Player) -> some View {
		PinEntryView(
			pin: deletePlayer.pin,
			didCancel: .init(
				get: { false },
				set: {_ in self.deletePlayer = nil }
			),
			didSucceed: .init(
				get: { false },
				set: {
					if $0 {
						viewModel.deletePlayer(deletePlayer)
						self.deletePlayer = nil
					}
				}
			)
		)
	}
	
	func playerRow(_ player: Player) -> some View {
		HStack {
			PlayerRow(player: player)
			Divider()
			NavigationLink(
				destination: editPlayerView(player),
				label: { HStack(alignment: .center) { Image(systemName: "pencil"); Text("Edit") }}
			).frame(width: 100)
		
		}
	}
	
	
	
	func deletePlayers(at offsets: IndexSet) {
		
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
	
	
	var header: some View {
		HStack {
			Text(editingMode ? "Edit Player" : "Select Player")
				.padding()
			Spacer()
			Toggle("", isOn: $editingMode)
			Text("Edit")
				.padding(.leading)
		}
	}
	
	
	
	func editPlayerView(_ player: Player?) -> some View {
		EditPlayerView(
			isPresented: $showEditor,
			player: player ?? .newPlayer,
			newPlayer: player == nil
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
	
}

struct PlayerRow: View {
	
	@State var player: Player
	
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
	}
	
	func updateAvatar() {
		guard player.avatarImage == nil else { return }
		player.loadAvatar { image in
			guard let image = image else { return }
			player.avatarImage = image
		}
	}
	
	var image: some View {
		let image: Image
		if let avatar = player.avatarImage {
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
