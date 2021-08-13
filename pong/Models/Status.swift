//
//  Status.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Foundation

enum MatchStatus: Int, CaseIterable {
	case pregame
	case guestChooseSide
	case ping 
	case playing
	case optionToExtend
	case matchComplete
	case postgame
}

