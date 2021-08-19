//
//  PossessionArrow.swift
//  PossessionArrow
//
//  Created by Charles Faquin on 8/16/21.
//

import SwiftUI

struct PossessionArrow: View {
	
	@ObservedObject var match: Match
	
	var body: some View {
		
		HStack {
			Image(systemName: "arrowtriangle.left\(imageSuffix(.left))")
				.resizable()
				.foregroundColor(imageColor(.left))
				.scaledToFit()
				.shadow(color: .green, radius: shadowRadius(.left), x: 0, y: 0)
				.padding()
			
				Text(text)
					.font(.system(size: 80, weight: .thin, design: .rounded))
					.minimumScaleFactor(0.5)
					.foregroundColor(textColor)
					.shadow(color: .white, radius: 3, x: 0, y: 0)
					.lineLimit(1)
					.frame(width: match.middlePanelWidth)
					.padding()
			
			Image(systemName: "arrowtriangle.right\(imageSuffix(.right))")
				.resizable()
				.foregroundColor(imageColor(.right))
				.scaledToFit()
				.shadow(color: .green, radius: shadowRadius(.right), x: 0, y: 0)
				.padding()
		}
		.frame(width: match.middlePanelWidth * 3)
		.padding()
	}
	
	var text: String {
		switch match.status {
		case .ping:
			return " P I N G "
		default:
			return " S E R V I C E "
		}
	}
	
	var textColor: Color {
		switch match.status {
		case .ping:
			return .green
		default:
			return .white
		}
	}
	
	
	
	func imageSuffix(_ side: TableSide) -> String {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return ""
		default:
			return side == serviceSide ? ".fill" : ""
		}
	}
	
	func imageColor(_ side: TableSide) -> Color {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return .gray
		default:
			return side == serviceSide ? .green : .gray
		}
	}
	
	func shadowRadius(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return 0
		default:
			return side == serviceSide ? 5 : 0
		}
	}
	
	var serviceSide: TableSide {
		switch match.game.service {
		case .home:
			return match.tableSides.home
		case .guest:
			return match.tableSides.guest
		}
	}
}

struct PossessionArrow_Previews: PreviewProvider {
	static var previews: some View {
		PossessionArrow(match: Match())
	}
}
