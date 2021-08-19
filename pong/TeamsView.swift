//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@ObservedObject var match: Match

	
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
	
	var teams: [Team] {
		[leftTeam, rightTeam]
	}
	
    var body: some View {
			HStack {
				teamView(leftTeam, tableSide: .left)
				Spacer()
				Rectangle()
					.foregroundColor(.clear)
					.frame(width: match.middlePanelWidth)
				Spacer()
				teamView(rightTeam, tableSide: .right)
			}
			.padding()
    }
		
	func teamView(_ team: Team, tableSide: TableSide) -> some View {
		GroupBox {
			Text(team.id.rawValue.uppercased())
				.font(.system(size: 100, weight: .semibold, design: .monospaced))
				.minimumScaleFactor(0.25)
				.padding()
				.frame(maxWidth: .infinity)
			Divider()
			HStack {
				if tableSide == .right { Spacer() }
				GroupBox {
					if match.status != .pregame {
						Button(team.user?.username ?? "Unknown Player", action: addUser)
							.padding()
					} else {
						Button("Add Player", action: addUser)
							.foregroundColor(Color(UIColor.systemTeal))
							.padding()
					}
				}
				if tableSide == .left { Spacer() }
			}
		}
	}
	
	func addUser() {
		
	}
}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
			TeamsView(match: Match())
    }
}
