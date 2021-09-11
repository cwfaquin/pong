//
//  ScoresView.swift
//  ScoresView
//
//  Created by Charles Faquin on 8/23/21.
//

import SwiftUI

struct ScoresView: View {
	
	@EnvironmentObject var match: Match
	@Binding var screenSize: CGSize
	
	var body: some View {
		HStack {
			scoreText(.left)
			Spacer(minLength: screenSize.width/3)
			scoreText(.right)
		}
		.overlay(match.status == .ping ? Color.black.opacity(0.8) : nil)
		.padding()
	}
	
	func scoreText(_ tableSide: TableSide) -> some View {
		Text(scoreText(tableSide))
			.font(.system(size: 1000, weight: .bold, design: .rounded))
			.foregroundColor(match.status.textColor)
			.shadow(color: match.status.textColor, radius: match.status.shadowRadious, x: 0, y: 0)
			.minimumScaleFactor(0.1)
			.multilineTextAlignment(.center)
			.padding([tableSide == .left ? .leading : .trailing, .bottom])
			.frame(maxWidth: .infinity)
	}
	
	func scoreText(_ tableSide: TableSide) -> String {
		switch match.teamID(tableSide) {
		case .home:
			return String(match.game.home)
		case .guest:
			return String(match.game.guest)
		}
	}

}

struct ScoresView_Previews: PreviewProvider {
	static var previews: some View {
		ScoresView(screenSize: .constant(CGSize(width: 500, height: 300)))
			.environmentObject(Match())
	}
}
