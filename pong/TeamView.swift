//
//  TeamView.swift
//  TeamView
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

struct TeamView: View {
	
	@EnvironmentObject var match: Match

	let tableSide: TableSide
	@Binding var showControlButtons: Bool
	@State private var choosingSide = false
	
    var body: some View {
			GroupBox {
				Text(match.teamID(tableSide).rawValue.uppercased().spaced)
					.font(.system(size: 50, weight: .regular, design: .monospaced))
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
			Button(action: addUser, label: { Label("Player", systemImage: "plus.circle") })
				.foregroundColor(._teal)
				.font(.title3)
				.minimumScaleFactor(0.75)
				.lineLimit(1)
		}
		.cornerRadius(10)
		.groupBoxStyle(BlackGroupBoxStyle(color: Color(UIColor.systemGray6)))
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
			TeamView(tableSide: .left, showControlButtons: .constant(true))
				.environmentObject(Match())
    }
}
