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
	@Published var recordMatchResults = false
	@Published var homeTeam = Team(.home)
	@Published var guestTeam = Team(.guest)
}

enum GameType: Int, CaseIterable, Identifiable {
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

enum SetType: Int, CaseIterable, Identifiable {
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
			return "1 game"
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

enum MatchType: Int, CaseIterable, Identifiable {
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
			return "1 set"
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



