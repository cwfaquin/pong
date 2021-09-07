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
	@Published var showControlButtons = true
	
}

protocol ScoreSetting: Identifiable  {
	var id: Int { get }
	var pointGoal: Int { get }
	var maxSeriesCount: Int { get }
	var description: String { get }
}

enum GameType: Int, CaseIterable, ScoreSetting {
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
	
	var id: Int {
		rawValue
	}
	
	var maxSeriesCount: Int {
		.zero
	}
	
	var description: String {
		"\(pointGoal) points"
	}
}

enum SetType: Int, CaseIterable, Identifiable, ScoreSetting {
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
	
	var id: Int {
		rawValue
	}
	
	var description: String {
		switch self {
		case .singleGame:
			return "1 Game"
		default:
			return "Best of \(maxSeriesCount)"
		}
	}
	
	var maxSeriesCount: Int {
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

enum MatchType: Int, CaseIterable, ScoreSetting {
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
	
	var id: Int {
		rawValue
	}
	
	var description: String {
		switch self {
		case .singleSet:
			return "1 Set"
		default:
			return "Best of \(maxSeriesCount)"
		}
	}
	
	var maxSeriesCount: Int {
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



