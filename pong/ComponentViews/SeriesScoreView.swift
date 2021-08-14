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
		LazyHStack(spacing: 20) {
				ForEach(0..<viewModel.winningScore) { index in
					Image(systemName: viewModel.imageNames[index])
						.aspectRatio(contentMode: .fit)
						.foregroundColor(Color(.cyan))
						.imageScale(.large)
				}
			}

	}
}

struct SeriesScoreView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesScoreView(viewModel: SeriesScoreVM())
	}
}

enum SeriesType {
	case set(SetType)
	case match(MatchType)
}
