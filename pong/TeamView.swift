//
//  TeamView.swift
//  TeamView
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

struct TeamView: View {
	
	@EnvironmentObject var match: Match
	@State var showPlayerSelection = false
	@Binding var player: Player?
	let tableSide: TableSide
	@Binding var showControlButtons: Bool
	@State private var choosingSide = false
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
    var body: some View {
			GroupBox {
				Text(match.teamID(tableSide).rawValue.uppercased())
					.font(notMacApp ? .largeTitle : .teamFont)
					.minimumScaleFactor(0.25)
					.lineLimit(1)
					.shadow(color: .white, radius: 3, x: 0, y: 0)
					.padding()
				Divider()
				HStack {
					switch tableSide {
					case .left:
						playerBox
						Spacer()
						if showControlButtons {
							scoreStepper
						}
					case .right:
						if showControlButtons {
							scoreStepper
						}
						Spacer()
						playerBox
					}
				}
			}
			.cornerRadius(10)
			.groupBoxStyle(BlackGroupBoxStyle(color: .black))
			.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(borderColor(tableSide), lineWidth: choosingSide ? 8 : lineWidth(tableSide))
						.shadow(color: borderColor(tableSide), radius: choosingSide ? 4 : 0, x: 0, y: 0)
			)
			.padding()
			.onChange(of: match.status) { newValue in
				switch newValue {
				case .guestChooseSide where isGuest:
					withAnimation(.linear(duration: 1.5).repeatForever()) {
						choosingSide = true
					}
				default:
					if choosingSide {
						withAnimation(.easeOut) {
							choosingSide = false
						}
					}
				}
			}
		}
}

extension TeamView {
	var playerBox: some View {
		GroupBox {
			if let player = player {
				PlayerRow(player: player)
					.onTapGesture {
						showPlayerSelection = true 
					}
			} else {
				Button(action: { showPlayerSelection = true }, label: { Label("Player", systemImage: "plus.circle") })
				.foregroundColor(._teal)
				.font(notMacApp ? .title3 : .title2)
				.lineLimit(1)
			}
		}
		.cornerRadius(10)
		.groupBoxStyle(BlackGroupBoxStyle(color: Color(UIColor.systemGray6)))
		.sheet(isPresented: $showPlayerSelection) {
			PlayerSelectionView(
				selectedPlayer: Binding.init(
					get: { player },
					set: {
						player = $0
						showPlayerSelection = false
					})
			)
		}
		}

				
	
	var scoreStepper: some View {
		Stepper("", onIncrement: { match.singleTap(tableSide) }, onDecrement: { match.doubleTap(tableSide) })
			.labelsHidden()
	}
	
	var isGuest: Bool {
		tableSide == match.tableSides.guest
	}
	
	func lineWidth(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .guestChooseSide:
			return isGuest ? 0 : 1.5
		default:
			return 1.5
		}
	}
	
	func borderColor(_ side: TableSide) -> Color {
		let gray = Color(UIColor.secondarySystemFill)
		switch match.status {
		case .guestChooseSide:
			return isGuest ? .green : gray
		default:
			return gray
		}
	}
	
	func addUser() {
	
	}
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
			TeamView(player: .constant(nil), tableSide: .left, showControlButtons: .constant(true))
				.environmentObject(Match())
    }
}
