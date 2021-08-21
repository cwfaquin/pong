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
	
	var bestOf: String {
		switch self {
		case .singleGame:
			return "Single Game"
		case .bestOfThree:
			return "Best of Three"
		case .bestOfFive:
			return "Best of Five"
		case .bestOfSeven:
			return "Best of Seven"
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
	
	var bestOf: String {
		switch self {
		case .singleSet:
			return "Single Set"
		case .bestOfThree:
			return "Best of Three"
		case .bestOfFive:
			return "Best of Five"
		case .bestOfSeven:
			return "Best of Seven"
		}
	}
}



