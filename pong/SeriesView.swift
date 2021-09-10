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
				SeriesScoreView(viewModels: $viewModel.leftScoreCircles)
					.frame(minHeight: 40, idealHeight: 70, maxHeight: 140)
					.padding(.trailing)

				Divider()
					.frame(minHeight: 40, idealHeight: 55, maxHeight: 60)

				Text(viewModel.text)
				.font(.largeTitle)
				.fontWeight(.ultraLight)
				.minimumScaleFactor(0.75)
				.lineLimit(1)
				.foregroundColor(viewModel.match.status.textColor)
				.shadow(color: viewModel.match.status.textColor, radius: viewModel.textShadowRadius, x: 0, y: 0)
				.frame(width: viewModel.panelWidth)
				.padding()
				
				
				Divider()
					.frame(minHeight: 40, idealHeight: 55, maxHeight: 60)


				SeriesScoreView(viewModels: $viewModel.rightScoreCircles)
					.frame(minHeight: 40, idealHeight: 70, maxHeight: 140)
					.padding(.leading)

				Spacer()
			}
			.onChange(of: viewModel.match.settings.setType) { _ in
				withAnimation(.easeOut) {
					viewModel.updateScoreCircles()
				}
			}
			.onChange(of: viewModel.match.settings.matchType) { _ in
				withAnimation(.easeOut) {
					viewModel.updateScoreCircles()
				}
			}
	}
	
}


struct SeriesView_Previews: PreviewProvider {
	static var previews: some View {
		SeriesView(viewModel: SeriesVM(Match(), seriesType: .set, panelWidth: 200))
	}
}


