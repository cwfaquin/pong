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
						.frame(minWidth: 20, idealWidth: 70, maxWidth: 80, minHeight: 20, idealHeight: 70, maxHeight: 80)
						.scaledToFit()
						.padding()
				}
		}.padding()
			
		
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
