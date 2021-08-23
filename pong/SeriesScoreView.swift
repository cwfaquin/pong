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
		HStack {
			ForEach(0..<4) { index in
				Image(systemName: viewModel.imageNames[index])
					.resizable()
					.scaledToFit()
					.foregroundColor(viewModel.foregoundColors[index])
					.shadow(color: viewModel.foregoundColors[index], radius: 3, x: 0, y: 0)
					.padding([.leading, .trailing])
			}
		}
	}
}

struct SeriesScoreView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesScoreView(viewModel: SeriesScoreVM(.left, currentScore: 0, winningScore: 3))
	}
}
