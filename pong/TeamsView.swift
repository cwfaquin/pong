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
			LazyHStack {
				teamView(leftTeam)
				teamView(rightTeam)
			}
    }
		
	func teamView(_ team: Team) -> some View {
		return GroupBox {
			Text(team.id.rawValue.uppercased())
				.font(.largeTitle)
				.fontWeight(.semibold)
				.padding()
			GroupBox {
				if match.status != .pregame {
					Text(team.user?.username ?? "Unknown Player")
				} else {
					if #available(macCatalyst 15.0, *) {
						Button("Add User", action: addUser)
							.controlSize(.large)
							.padding()
					} else {
							Button("Add User", action: addUser)
								.padding()
					}
				}
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
