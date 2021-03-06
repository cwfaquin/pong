//
//  SeriesView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct SeriesView: View {
	
	@ObservedObject var viewModel: SeriesVM
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		HStack(alignment: .center) {
			Spacer()
			SeriesScoreView(viewModels: $viewModel.leftScoreCircles)
				.frame(minHeight: 40, idealHeight: notMacApp ? 60 : 70, maxHeight: notMacApp ? 70 : 120)
				.padding(.trailing)
			
			Divider()
				.frame(minHeight: notMacApp ? 10 : 40, idealHeight: notMacApp ? 30 : 55, maxHeight: notMacApp ? 44: 60)
				.padding(.leading)
			
			Text(viewModel.text)
				.font(notMacApp ? .title : .seriesFont)
				.fontWeight(.ultraLight)
				.minimumScaleFactor(0.55)
				.lineLimit(1)
				.foregroundColor(viewModel.match.status.textColor)
				.shadow(color: viewModel.match.status.textColor, radius: viewModel.textShadowRadius, x: 0, y: 0)
				.frame(width: viewModel.panelWidth)
				.padding()
			
			Divider()
				.frame(minHeight: notMacApp ? 10 : 40, idealHeight: notMacApp ? 30 : 55, maxHeight: notMacApp ? 44: 60)
				.padding(.trailing)
			
			SeriesScoreView(viewModels: $viewModel.rightScoreCircles)
				.frame(minHeight: 40, idealHeight: notMacApp ? 60 : 70, maxHeight: notMacApp ? 70 : 120)
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


