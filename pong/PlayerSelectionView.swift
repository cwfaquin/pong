//
//  PlayerSelectionView.swift
//  PlayerSelectionView
//
//  Created by Charles Faquin on 9/17/21.
//

import SwiftUI
import CloudKit

struct PlayerSelectionView: View {
	@StateObject var viewModel: PlayerSelectionVM
	@Binding var selectedPlayer: Player?
	@State var editingPlayer: Player?
	@Binding var isShowing: Bool
	
	
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
						ForEach(viewModel.players, id: \.id) { player in
							PlayerRow(player)
								.onTapGesture {
									selectedPlayer = player
								}
						}
					}
				}
				if viewModel.isLoading {
					ZStack {
						Rectangle()
							.foregroundColor(.black.opacity(0.9))
						ProgressView()
							.progressViewStyle(.circular)
					}
				}
			}
			
			.navigationTitle("Choose Player")
			.navigationBarItems(trailing:
														NavigationLink(
															destination: {
																EditPlayerView(player: newPlayer)
																	.environmentObject(viewModel)
															},
															label: {
																Label("New Player", systemImage: "plus")
																	.foregroundColor(.pink)
																	.font(notMacApp ? .title3 : .title2)
																	.padding()
															}
														)
														.navigationTitle("New Player")
			)
			
		}
		.accentColor(.pink)
		.onAppear {
			viewModel.fetchPlayers()
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onChange(of: viewModel.selectedPlayer) { newValue in
			selectedPlayer = newValue
			isShowing = false
		}
		
	}
	
	var newPlayer: Player {
		Player(record: CKRecord(recordType: Player.recordType))
	}
}



struct PlayerRow: View {
	
	@State var avatar: UIImage?
	var player: Player
	
	init(_ player: Player) {
		self.player = player
	}
	
	var body: some View {
		HStack {
			avatarImage
			VStack {
				Text(player.username)
					.font(.headline)
				Text("\(player.firstName) \(player.lastName)")
					.font(.subheadline)
			}
			Text("")
		}
		.onAppear {
			player.loadAvatar { image in
				avatar = image
			}
		}
	}
	
	var avatarImage: some View {
		let image: Image
		if let avatar = avatar {
			image = Image(uiImage: avatar)
		} else {
			image = Image(systemName: "person.fill")
		}
		return image
			.imageScale(.large)
			.overlay(
				Circle()
					.strokeBorder(style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
					.foregroundColor(.pink)
			)
			.padding()
	}
}



struct PlayerSelectionView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerSelectionView(viewModel: PlayerSelectionVM(), selectedPlayer: .constant(nil), editingPlayer: nil, isShowing: .constant(true))
	}
}
