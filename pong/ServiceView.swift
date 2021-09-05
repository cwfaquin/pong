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
			serviceTextBox
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
			.shadow(color: .green, radius: viewModel.arrowShadowRadius(tableSide), x: 0, y: 0)
			.padding(tableSide == .left ? .trailing : .leading)
	}
	
	var serviceTextBox: some View {
		GroupBox {
			Text(viewModel.text)
				.font(.system(size: 50, weight: .regular, design: .rounded))
				.minimumScaleFactor(0.1)
				.lineLimit(1)
				.foregroundColor(viewModel.textColor)
				.shadow(color: viewModel.textColor, radius: viewModel.textShadowRadius, x: 0, y: 0)
				.padding()
		}
		.groupBoxStyle(BlackGroupBoxStyle())
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(viewModel.textColor, lineWidth: 1)
				.shadow(color: viewModel.textColor, radius: viewModel.textShadowRadius, x: 0, y: 0)
		)
		.layoutPriority(2)
		.frame(width: viewModel.panelWidth * 1.0)
	}
}

struct ServiceView_Previews: PreviewProvider {
	static var previews: some View {
		ServiceView(viewModel: ServiceVM(Match(), panelWidth: 200))
	}
}
