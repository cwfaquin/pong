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
	@Published var circleCount: Int
	
	let alignment: Alignment
	
	private let empty: String = "circle"
	private let filled: String = "largecircle.fill.circle"
	
	init(_ tableSide: TableSide, currentScore: Int, winningScore: Int, circleCount: Int) {
		self.tableSide = tableSide
		self.currentScore = currentScore
		self.winningScore = winningScore
		switch tableSide {
		case .left:
			alignment = .trailing
		case .right:
			alignment = .leading
		}
		self.circleCount = circleCount
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
	
	var foregoundColors: [Color] {
		var array = Array(1...winningScore)
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


