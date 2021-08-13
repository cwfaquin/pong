//
//  GameView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct GameView: View {
	
	@ObservedObject var match: Match
	
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
				Text(String(rightScore))
					.font(.system(size:size, weight: .bold, design: .monospaced))
					.multilineTextAlignment(.center)
					.scaledToFill()
			}
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
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
			GameView(match: Match())
    }
}
