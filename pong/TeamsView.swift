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
				.frame(maxWidth: .infinity)
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
	
	func addUser() {
		
	}
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(match: Match())
	}
}
