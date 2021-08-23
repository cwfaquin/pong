//
//  ServiceVM.swift
//  ServiceVM
//
//  Created by Charles Faquin on 8/23/21.
//

import Combine
import SwiftUI

final class ServiceVM: ObservableObject {
	
	@ObservedObject var match: Match

	
	init(_ match: Match) {
		self.match = match
	}

	var text: String {
		switch match.status {
		case .ping:
			return "ping".uppercased().spaced
		default:
			return "service".uppercased().spaced
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
	
	func imageName(_ tableSide: TableSide) -> String {
		let base = "arrowtriangle.\(tableSide.text)"
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return base
		default:
			return tableSide == match.serviceSide ? "\(base).fill" : base
		}
	}
	
	func imageColor(_ side: TableSide) -> Color {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return .gray
		default:
			return side == match.serviceSide ? .green : .gray
		}
	}
	
	func shadowRadius(_ side: TableSide) -> CGFloat {
		switch match.status {
		case .ping, .pregame, .guestChooseSide:
			return 0
		default:
			return side == match.serviceSide ? 5 : 0
		}
	}
}
