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
	@Binding var isShowing: Bool
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
						ForEach(viewModel.players, id: \.id) { player in
							playerRow(player)      
							.listRowBackground(player == selectedPlayer ? Color.black : Color.clear)
							.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
						}
					}
					.listItemTint(.blue)
			}
				NavigationLink(destination: editPlayerView(editingPlayer), isActive: $showEditor) {
					EmptyView()
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
			if editingMode {
				Button(action: { deletePlayer = player }) {
					Image(systemName: "minus.circle")
						.resizable()
						.foregroundColor(.pink)
						.frame(width: 30, height: 30)
				}.padding(.leading)
			}
			HStack {
			PlayerRow(player: player)
			if editingMode {
				HStack {
					Image(systemName: "pencil.circle")
						.resizable()
						.foregroundColor(.blue)
						.frame(width: 30, height: 30)
					Image(systemName: "chevron.right")
						.imageScale(.large)
						.foregroundColor(.gray)
				}
				.padding(.trailing)
				.onTapGesture {
						editingPlayer = player
						showEditor = true
					}
				}
			}
			.onTapGesture {
				if !editingMode {
					selectedPlayer = player == selectedPlayer ? nil : player
					isShowing = false
				} else {
					editingPlayer = player
					showEditor = true
				}
			}
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
		}.padding(.trailing)
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
			Image(uiImage: player.avatarImage ?? UIImage())
				.resizable()
				.foregroundColor(.blue)
				.frame(width: 50, height: 50)
				.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				.padding()
			Text(player.username)
				.font(.title)
				.foregroundColor(.white)
			Spacer()
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
			
	}
}





struct PlayerSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerSelectionView(selectedPlayer: .constant(nil), isShowing: .constant(true), teamID: .home)
	}
}
