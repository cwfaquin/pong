//
//  SeriesView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct SeriesView: View {
	
	@ObservedObject var viewModel: SeriesVM
	
	var body: some View {
			HStack(alignment: .center) {
				Spacer()
				SeriesScoreView(viewModel: viewModel.leftScoreVM)
					.frame(minHeight: 40, idealHeight: 70, maxHeight: 140)
					.padding(.trailing)

				Divider()
					.frame(minHeight: 40, idealHeight: 55, maxHeight: 60)

				Text(viewModel.text)
				.font(.largeTitle)
				.fontWeight(.ultraLight)
				.minimumScaleFactor(0.75)
				.lineLimit(1)
				.shadow(color: .white, radius: 2, x: 0, y: 0)
				.frame(width: viewModel.panelWidth)
				.padding()
				
				
				Divider()
					.frame(minHeight: 40, idealHeight: 55, maxHeight: 60)


				SeriesScoreView(viewModel: viewModel.rightScoreVM)
					.frame(minHeight: 40, idealHeight: 70, maxHeight: 140)
					.padding(.leading)

				Spacer()
			
			
		
		}
	}
	
}


struct SeriesView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesView(viewModel: SeriesVM(Match(), seriesType: .set, panelWidth: 200))
	}
}


