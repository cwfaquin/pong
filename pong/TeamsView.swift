//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@ObservedObject var match: Match
	
	var body: some View {
		HStack {
			teamView(leftTeam, tableSide: .left)
			Spacer()
			Rectangle()
				.foregroundColor(.clear)
				.frame(width: match.middlePanelWidth)
				.layoutPriority(-1)
			Spacer()
			teamView(rightTeam, tableSide: .right)
		}
		.fixedSize(horizontal: false, vertical: false)
		.padding()
	}
	
	
	var leftTeam: Team {
		switch match.teamID(.left) {
		case .home:
			return match.home
		case .guest:
			return match.guest
		}
	}
	
	var rightTeam: Team {
		switch match.teamID(.right) {
		case .home:
			return match.home
		case .guest:
			return match.guest
		}
	}
	
	
	func teamView(_ team: Team, tableSide: TableSide) -> some View {
		GroupBox {
			Text(team.id.rawValue.uppercased())
				.font(.system(size: 100, weight: .semibold, design: .monospaced))
				.lineLimit(1)
				.minimumScaleFactor(0.25)
				.padding()
				.shadow(color: .white, radius: 2.5, x: 0, y: 0)
			Divider()
			HStack {
				switch tableSide {
				case .left:
					makePlayerBox(team)
					Spacer()
					makeStepper(tableSide)
				case .right:
					makeStepper(tableSide)
					Spacer()
					makePlayerBox(team)
				}
			}
		}
		.cornerRadius(10)
		.padding(5)
		.groupBoxStyle(BlackGroupBoxStyle(color: .black))
		.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(borderColor(tableSide), lineWidth: 2)
					.shadow(color: borderColor(tableSide), radius: shadowRadius(tableSide), x: 0, y: 0)
		)
	}
	
	func makePlayerBox(_ team: Team) -> some View {
		GroupBox {
			Button(action: addUser, label: { Label("Player", systemImage: "plus.circle") })
				.foregroundColor(Color(UIColor.systemTeal))
				.padding()
				.font(.title)
		}
	}
	
	
	func makeStepper(_ tableSide: TableSide) -> some View {
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
		let random = Int.random(in: 0..<ScoreboardVM.SoundType.allCases.count)
		let sound = ScoreboardVM.SoundType.allCases[random]
		print(sound.rawValue)
		ScoreboardVM.playSound(sound)
	}
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(match: Match())
	}
}
