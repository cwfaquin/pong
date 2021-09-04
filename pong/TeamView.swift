//
//  TeamView.swift
//  TeamView
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

struct TeamView: View {
	
	@ObservedObject var match: Match
	let tableSide: TableSide
	
    var body: some View {
			GroupBox {
				Text(match.teamID(tableSide).rawValue.uppercased().spaced)
					.font(.system(size: 50, weight: .regular, design: .monospaced))
					//.minimumScaleFactor(0.75)
					.lineLimit(1)
					.shadow(color: .white, radius: 2.5, x: 0, y: 0)
					.padding()
				Divider()
				HStack {
					switch tableSide {
					case .left:
						playerBox
						Spacer()
						scoreStepper
					case .right:
						scoreStepper
						Spacer()
						playerBox
					}
				}
			}
			.cornerRadius(10)
			.groupBoxStyle(BlackGroupBoxStyle(color: .black))
			.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(borderColor(tableSide), lineWidth: 2)
						.shadow(color: borderColor(tableSide), radius: shadowRadius(tableSide), x: 0, y: 0)
			)
			.padding()
		}
}

extension TeamView {
	var playerBox: some View {
		GroupBox {
			Button(action: addUser, label: { Label("Player", systemImage: "plus.circle") })
				.foregroundColor(Color(UIColor.systemTeal))
				.font(.title3)
				.minimumScaleFactor(0.75)
				.lineLimit(1)
		}
	}
	
	var scoreStepper: some View {
		Stepper("", onIncrement: { match.singleTap(tableSide) }, onDecrement: { match.doubleTap(tableSide) })
			.labelsHidden()
	}
	
	func shadowRadius(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .ping, .pregame:
			return 0
		case .guestChooseSide:
			return side == match.tableSides.guest ? 3 : 0
		default:
			return side == match.serviceSide ? 3 : 0
		}
	}
	
	func borderColor(_ side: TableSide) -> Color {
		let gray = Color(UIColor.secondarySystemFill)
		switch match.status {
		case .ping, .pregame:
			return gray
		case .guestChooseSide:
			return side == match.tableSides.guest ? .green : gray
		default:
			return side == match.serviceSide ? .green : gray
		}
	}
	
	func addUser() {
	
	}
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
			TeamView(match: Match(), tableSide: .left)
    }
}
