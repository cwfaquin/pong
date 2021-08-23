//
//  SeriesView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct SeriesView: View {
	
	@ObservedObject var viewModel: SeriesVM
	@State var textWidth: CGFloat = 0
	
	var body: some View {
		HStack {
			SeriesScoreView(viewModel: viewModel.leftScoreVM)
			Divider()
				.padding()
			Text(viewModel.text)
				.font(.largeTitle)
				.fontWeight(.ultraLight)
				.minimumScaleFactor(0.5)
				.lineLimit(1)
				.minimumScaleFactor(0.5)
				.shadow(color: .white, radius: 2, x: 0, y: 0)
				.frame(width: textWidth)
				
			Divider()
				.padding()
			SeriesScoreView(viewModel: viewModel.rightScoreVM)
		}
		.fixedSize(horizontal: false, vertical: true)
		.readSize { size in
			textWidth = max(50, size.width/5)
		}
	}

}

struct SeriesView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesView(viewModel: SeriesVM(Match(), seriesType: .set))
	}
}
