//
//  ScoreView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI
import Combine

struct ScoreView: View {
	
	@ObservedObject var match: Match
	
	let size = UIScreen.main.bounds.height/3
	
    var body: some View {
			HStack {
				VStack {
					Text(leftID.rawValue.uppercased())
						.font(.title)
						.padding()
					Text(String(leftScore))
						.font(.system(size: 1000, weight: .bold, design: .rounded))
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.minimumScaleFactor(0.1)
						.lineLimit(1)
						.border(leftColor, width: 1)
				}.padding()
				VStack {
					Text(rightID.rawValue.uppercased())
						.font(.title)
						.padding()
					Text(String(rightScore))
						.font(.system(size: 1000, weight: .bold, design: .rounded))
						.minimumScaleFactor(0.1)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.lineLimit(1)
						.border(rightColor, width: 1)
				}.padding()
			}
			.fixedSize(horizontal: false, vertical: false)
    }
	
	var leftID: TeamID {
		match.teamID(.left)
	}
	
	var rightID: TeamID {
		match.teamID(.right)
	}
	
	var leftColor: Color {
		if leftID == match.game.service {
			return Color.green
		}
		return Color.blue
	}
	
	var rightColor: Color {
		if rightID == match.game.service {
			return Color.green
		}
		return Color.blue
	}
	
	var leftScore: Int {
		switch match.tableSides.home {
		case .left:
			return match.game.home
		case .right:
			return match.game.guest
		}
	}
	
	var rightScore: Int {
		switch match.tableSides.guest {
		case .left:
			return match.game.home
		case .right:
			return match.game.guest
		}
	}
	
	var leftTeam: TeamID {
		switch match.tableSides.home {
		case .left:
			return .home
		case .right:
			return .guest
		}
	}
	
	var rightTeam: TeamID {
		switch match.tableSides.guest {
		case .left:
			return .home
		case .right:
			return .guest
		}
	}
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
			ScoreView(match: Match())
    }
}
