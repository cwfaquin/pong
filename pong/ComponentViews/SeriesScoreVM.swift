//
//  SeriesScoreVM.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

class SeriesScoreVM: ObservableObject {
	
	@Published var tableSide: TableSide
	@Published var currentScore: Int
	@Published var winningScore: Int
	
	private let empty: String = "circle"
	private let filled: String = "circle.inset.filled"
	
	init(tableSide: TableSide = .left, currentScore: Int = 0, winningScore: Int = 3) {
		self.tableSide = tableSide
		self.currentScore = currentScore
		self.winningScore = winningScore
	}

	var imageNames: [String] {
		let names = Array(1...winningScore)
			.compactMap { $0 > currentScore ? empty : filled }
		switch tableSide {
		case .left:
			return names.reversed()
		case .right:
			return names
		}
	}
}


