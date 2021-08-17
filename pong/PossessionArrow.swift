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
					.padding()
					.scaledToFit()
					.shadow(color: .green, radius: shadowRadius(.left), x: 0, y: 0)
					.shadow(radius: shadowRadius(.left))
				Text("S E R V I C E")
					.font(.system(size: 50, weight: .ultraLight, design: .rounded))
					.frame(width: match.middlePanelWidth)
				Image(systemName: "arrowtriangle.right\(imageSuffix(.right))")
					.resizable()
					.foregroundColor(imageColor(.left))
					.padding()
					.scaledToFit()
					.shadow(color: .green, radius: shadowRadius(.right), x: 0, y: 0)
					.shadow(radius: shadowRadius(.right))
			}.frame(width: match.geoSize.width/3)
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
			return .green
		default:
			return side == serviceSide ? .green : .gray
		}
	}
	
	func shadowRadius(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return 0
		default:
			return side == serviceSide ? 3 : 0
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
