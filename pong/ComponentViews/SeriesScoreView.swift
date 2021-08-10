//
//  SeriesScoreView.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import SwiftUI

struct SeriesScoreView: View {

	@State var viewModel: SeriesScoreVM
	
	var alignment: Alignment {
		switch viewModel.tableSide {
		case .left:
			return .trailing
		case .right:
			return .leading
		}
	}
	
	var body: some View {
		LazyHStack(spacing: 20) {
				ForEach(0..<viewModel.winningScore) { index in
					Image(systemName: viewModel.imageNames[index])
						.aspectRatio(contentMode: .fit)
						.foregroundColor(.green)
						.imageScale(.large)
				}
			}
			.frame(alignment: alignment)
			.fixedSize(horizontal: false, vertical: false)
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
