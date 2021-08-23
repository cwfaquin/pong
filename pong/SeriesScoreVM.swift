//
//  SeriesScoreVM.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import Combine
import SwiftUI

final class SeriesScoreVM: ObservableObject {
	
	@Published var tableSide: TableSide
	@Published var currentScore: Int
	@Published var winningScore: Int
	
	private let empty: String = "circle"
	private let filled: String = "largecircle.fill.circle"
	
	init(_ tableSide: TableSide, currentScore: Int, winningScore: Int) {
		self.tableSide = tableSide
		self.currentScore = currentScore
		self.winningScore = winningScore
	}

	var imageNames: [String] {
		let names = Array(1...4)
			.compactMap { $0 > currentScore ? empty : filled }
		switch tableSide {
		case .left:
			return names.reversed()
		case .right:
			return names
		}
	}
	
	var foregoundColors: [Color] {
		var array = Array(1...4)
		switch tableSide {
		case .left:
			array = array.reversed()
		case .right:
			break
		}
		return array
			.compactMap { $0 > winningScore ? .clear : Color(.cyan) }
	}

}


