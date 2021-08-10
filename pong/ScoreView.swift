//
//  ScoreView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct ScoreView: View {
	
	@State var gameScore: Score
	@State var gameSide: GameSide
	
	let size = UIScreen.main.bounds.height/3
	
    var body: some View {
			HStack {
				VStack {
					Text(leftTeam.rawValue.uppercased())
						.font(.title)
						.padding()
					Text(String(leftScore))
						.font(.system(size: size, weight: .bold, design: .monospaced))
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.multilineTextAlignment(.center)
						.border(Color.blue, width: 1)

				}.padding()
				VStack {
					Text(rightTeam.rawValue.uppercased())
						.font(.title)
						.padding()
					Text(String(rightScore))
						.font(.system(size: size, weight: .bold, design: .rounded))
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.multilineTextAlignment(.center)
						.border(Color.blue, width: 1)
				}.padding()
			}
			.fixedSize(horizontal: false, vertical: false)
    }
	
	var leftScore: Int {
		switch gameSide.home {
		case .left:
			return gameScore.home
		case .right:
			return gameScore.guest
		}
	}
	
	var rightScore: Int {
		switch gameSide.guest {
		case .left:
			return gameScore.home
		case .right:
			return gameScore.guest
		}
	}
	
	var leftTeam: TeamID {
		switch gameSide.home {
		case .left:
			return .home
		case .right:
			return .guest
		}
	}
	
	var rightTeam: TeamID {
		switch gameSide.guest {
		case .left:
			return .home
		case .right:
			return .guest
		}
	}
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(gameScore: Score(), gameSide: GameSide())
    }
}
