//
//  MatchSettings.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Foundation

final class MatchSettings: ObservableObject {
	@Published var gameType: GameType = .long
	@Published var setType: SetType = .bestOfThree
	@Published var matchType: MatchType = .singleSet
}

enum GameType: Int, CaseIterable {
	case short = 11
	case long = 21
}

enum SetType: CaseIterable {
	case singleGame
	case bestOfThree
	
	var pointGoal: Int {
		switch self {
		case .singleGame:
			return 1
		case .bestOfThree:
			return 2
		}
	}
}

enum MatchType: CaseIterable {
	case singleSet
	case bestOfThree
	case bestOfFive
	case bestOfSeven
	
	var pointGoal: Int {
		switch self {
		case .singleSet:
			return 1
		case .bestOfThree:
			return 2
		case .bestOfFive:
			return 3
		case .bestOfSeven:
			return 4
		}
	}
}



