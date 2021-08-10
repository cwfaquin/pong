//
//  Status.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Foundation

enum GameStatus {
	case pregame
	case start(service: TeamID, homeSide: TableSide)
	case paused(Date)
	case regularPoint(homeScore: Int, guestScore: Int)
	case gamePoint(teamOne: Int, teamTwo: Int)
	case deuceTwenty
	case deuce(tieScore: Int)
	case advantageOut(teamOne: Int, teamTwo: Int)
	case gameOver(winner: TeamID)
}

enum SetStatus {
	case pregame
	case ping
	case inProgress(homeGames: Int, guestGames: Int)
	case paused(Date)
	case setComplete(winner: TeamID)
}

enum MatchStatus {
	case pregame
	case inProgress(homeSets: Int, awaySets: Int)
	case paused(Date)
	case cancelled
	case gameSetMatch(winner: TeamID)
}
