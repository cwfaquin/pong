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
					Image(systemName: viewModel.imageNames[index])
						.resizable()
						.foregroundColor(viewModel.foregoundColors[index])
						.frame(minWidth: 10, idealWidth: 50, maxWidth: 60, minHeight: 10, idealHeight: 50, maxHeight: 60)
						.scaledToFit()
						.padding()
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
