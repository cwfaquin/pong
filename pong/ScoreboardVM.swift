//
//  ScoreboardVM.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Combine
import SwiftUI

final class ScoreboardVM: ObservableObject {
			
	@Published var home = Team(.home)
	@Published var guest = Team(.guest)

	
	func didSelect(_ user: User) {
		switch user.teamId {
		case .home:
			home.user = user
		case .guest:
			guest.user = user
		}
	}
	
	
}
