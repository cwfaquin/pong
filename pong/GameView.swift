//
//  GameView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct GameView: View {
	@State var gameScore: Score
	@State var gameSide: GameSide
	
	let size = UIScreen.main.bounds.width/3
	
		var body: some View {
			HStack {
				Text(String(leftScore))
					.font(.system(size: size, weight: .bold, design: .monospaced))
					.multilineTextAlignment(.center)
					.scaledToFill()
				Divider()
					.foregroundColor(.gray)
					.padding()
				Text(String(21))
					.font(.system(size:size, weight: .bold, design: .monospaced))
					.multilineTextAlignment(.center)
					.scaledToFill()
			}
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
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameScore: Score(), gameSide: GameSide())
    }
}
