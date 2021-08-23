//
//  PossessionArrow.swift
//  PossessionArrow
//
//  Created by Charles Faquin on 8/16/21.
//

import SwiftUI

struct ServiceView: View {
	
	@ObservedObject var viewModel: ServiceVM
	
	var body: some View {
		
		HStack {
			arrowImage(.left)
			
			Text(viewModel.text)
				.font(.largeTitle)
				.fontWeight(.regular)
				.minimumScaleFactor(0.5)
				.foregroundColor(viewModel.textColor)
				.shadow(color: .white, radius: 3, x: 0, y: 0)
				.lineLimit(1)
			
			arrowImage(.right)
		}
		.fixedSize()
		.padding()
	}
	
	func arrowImage(_ tableSide: TableSide) -> some View {
		return Image(systemName: viewModel.imageName(tableSide))
			.imageScale(.large)
			.foregroundColor(viewModel.imageColor(.right))
			.shadow(color: .green, radius: viewModel.shadowRadius(.right), x: 0, y: 0)
			.padding()
	}
	

}

struct ServiceView_Previews: PreviewProvider {
	static var previews: some View {
		ServiceView(viewModel: ServiceVM(Match()))
	}
}
