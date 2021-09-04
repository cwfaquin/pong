//
//  SeriesScoreView.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import SwiftUI

struct SeriesScoreView: View {
	
	@ObservedObject var viewModel: SeriesScoreVM
	
	var body: some View {
		
		HStack(alignment: .center, spacing: 20) {
			ForEach(0..<viewModel.winningScore) { index in
				Image(systemName: viewModel.imageNames[index])
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(viewModel.foregoundColors[index])
					.shadow(color: viewModel.foregoundColors[index], radius: 3, x: 0, y: 0)
					.padding()
			}
		}
		
	}
}

struct SeriesScoreView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesScoreView(viewModel: SeriesScoreVM(.left, currentScore: 0, winningScore: 3, circleCount: 3))
	}
}
