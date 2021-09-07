//
//  PossessionArrow.swift
//  PossessionArrow
//
//  Created by Charles Faquin on 8/16/21.
//

import SwiftUI

struct ServiceView: View {
	
	@State var isAnimating = false
	
	@ObservedObject var viewModel: ServiceVM
	
	var body: some View {
		
			HStack {
				arrowImage(.left)
				serviceTextBox()
				arrowImage(.right)
			}
			.frame(width: viewModel.panelWidth * 2)
			.padding()
			.scaleEffect(isAnimating ? 1.5 : 1)
		
			Rectangle()
				.foregroundColor(.clear)
				.frame(height: 100)
				.fixedSize(horizontal: false, vertical: true)
				.onChange(of: viewModel.match.status) { newValue in
					switch newValue {
					case .ping:
						withAnimation(.easeInOut(duration: 2).repeatForever()) {
							isAnimating = true
						}
					default:
						if isAnimating {
							withAnimation(.easeInOut) {
								isAnimating = false
							}
						}
					}
				}
	}
	
	func arrowImage(_ tableSide: TableSide) -> some View {
		return Image(systemName: viewModel.imageName(tableSide))
			.resizable()
			.scaledToFit()
			.foregroundColor(isAnimating ? .green : viewModel.imageColor(tableSide))
			.shadow(color: .green, radius: isAnimating ? 8 : viewModel.arrowShadowRadius(tableSide), x: 0, y: 0)
			.padding(tableSide == .left ? .trailing : .leading)
	}
	
	func serviceTextBox() -> some View {
		GroupBox {
			Text(viewModel.text)
				.font(.system(size: 50, weight: .regular, design: .rounded))
				.minimumScaleFactor(0.1)
				.lineLimit(1)
				.foregroundColor(viewModel.textColor)
				.shadow(color: viewModel.textColor, radius: isAnimating ? 8 : viewModel.textShadowRadius, x: 0, y: 0)
				.padding()
		}
		.groupBoxStyle(BlackGroupBoxStyle())
		.cornerRadius(10)
		.overlay(
			RoundedRectangle(cornerRadius: 10)
				.stroke(viewModel.textColor, lineWidth: isAnimating ? 5 : 1)
				.shadow(color: viewModel.textColor, radius: isAnimating ? 8 : viewModel.textShadowRadius, x: 0, y: 0)
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
