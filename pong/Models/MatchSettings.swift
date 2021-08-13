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
	@Published var optionToExtend: Bool = true 
}

protocol PointGoal {
	var pointGoal: Int { get }
}

enum GameType: CaseIterable, PointGoal {
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

enum SetType: CaseIterable, PointGoal {
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

enum MatchType: CaseIterable, PointGoal {
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



