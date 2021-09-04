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
					.font(.system(size: 50, weight: .regular, design: .rounded))
					.lineLimit(1)
					.foregroundColor(viewModel.textColor)
					.shadow(color: .white, radius: 3, x: 0, y: 0)
					.padding()
					.layoutPriority(2)
				
				arrowImage(.right)
			}
			.frame(width: viewModel.panelWidth * 2)
			.padding()
		
		Rectangle()
			.foregroundColor(.clear)
			.frame(height: 100)
		
	}
	
	func arrowImage(_ tableSide: TableSide) -> some View {
		return Image(systemName: viewModel.imageName(tableSide))
			.resizable()
			.scaledToFit()
			.foregroundColor(viewModel.imageColor(tableSide))
			.shadow(color: .green, radius: viewModel.shadowRadius(tableSide), x: 0, y: 0)
	}
	

}

struct ServiceView_Previews: PreviewProvider {
	static var previews: some View {
		ServiceView(viewModel: ServiceVM(Match(), panelWidth: 200))
	}
}
