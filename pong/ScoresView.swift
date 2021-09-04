//
//  ScoresView.swift
//  ScoresView
//
//  Created by Charles Faquin on 8/23/21.
//

import SwiftUI

struct ScoresView: View {
	
	@ObservedObject var viewModel: ScoresVM
	

    var body: some View {
			
			HStack {
				scoreText(.left)
				Spacer(minLength: viewModel.screenSize.width/3)
				scoreText(.right)
			}.padding()
    }
	
	
	func scoreImage(_ tableSide: TableSide) -> some View {
		Image(systemName: viewModel.scoreImageName(tableSide))
			.resizable()
			.scaledToFill()
			.foregroundColor(.black)
			.background(
				Circle()
					.foregroundColor(.white)
					.padding(4)
			)
			.padding()
	}
	
	func scoreText(_ tableSide: TableSide) -> some View {
		Text(viewModel.scoreText(tableSide))
			.font(.system(size: 1000, weight: .bold, design: .rounded))
			.minimumScaleFactor(0.1)
			.multilineTextAlignment(.center)
			.padding([tableSide == .left ? .leading : .trailing, .bottom])
			.frame(maxWidth: .infinity)
		
	}
	
	func arrowImage(_ tableSide: TableSide, width: CGFloat) -> some View {
		Image(systemName: viewModel.arrowImageName(tableSide))
			.resizable()
			.scaledToFit()
			.foregroundColor(viewModel.imageColor(.right))
			.shadow(color: .green, radius: viewModel.shadowRadius(.right), x: 0, y: 0)
			.frame(width: width)
			.fixedSize()
			.padding()
	}
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
			ScoresView(viewModel: ScoresVM(Match(), screenSize: CGSize(width: 500, height: 300)))
    }
}
