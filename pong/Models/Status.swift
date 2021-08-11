//
//  Status.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Foundation

enum MatchStatus: Int, CaseIterable {
	case pregame // guest choose side
	case ping // ping
	case playing
	case gameComplete
	case setComplete
	case matchComplete
}

