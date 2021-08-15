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
		LazyHStack {
				ForEach(0..<4) { index in
					Circle()
						.foregroundColor(viewModel.foregoundColors[index])
						.padding()
						.scaledToFill()
					/*GroupBox {
						Image(systemName: viewModel.imageNames[index])
							.foregroundColor(viewModel.foregoundColors[index])
							.aspectRatio(1, contentMode: .fill)
					}
					}*/
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
