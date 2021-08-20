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

protocol PointGoal {
	var pointGoal: Int { get }
}

enum GameType: Int, CaseIterable, PointGoal {
	case short
	case long
	
	var pointGoal: Int {
		switch self {
		case .long:
			return 21
		case .short:
			return 11
		}
	}
	
}

enum SetType: Int, CaseIterable, PointGoal {
	case singleGame
	case bestOfThree
	case bestOfFive
	case bestOfSeven
	
	var pointGoal: Int {
		switch self {
		case .singleGame:
			return 1
		case .bestOfThree:
			return 2
		case .bestOfFive:
			return 3
		case .bestOfSeven:
			return 4
		}
	}
	
	var bestOf: Int {
		switch self {
		case .singleGame:
			return 1
		case .bestOfThree:
			return 3
		case .bestOfFive:
			return 5
		case .bestOfSeven:
			return 7
		}
	}
}

enum MatchType: Int, CaseIterable, PointGoal {
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
	
	var bestOf: Int {
		switch self {
		case .singleSet:
			return 1
		case .bestOfThree:
			return 3
		case .bestOfFive:
			return 5
		case .bestOfSeven:
			return 7
		}
	}
}



