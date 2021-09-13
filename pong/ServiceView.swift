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
	let screenHeight = UIScreen.main.bounds.height
	@State var blink = false
	@State var isMovingBall = false
	@State var serviceSide: TableSide?
	@State var isAnimatingBallShadow = false
	
	var body: some View {
		
		VStack {
			HStack {
				arrowImage(.left)
				if isAnimating {
					Text(isAnimating ? viewModel.text : "")
						.font(.serviceFont)
						.minimumScaleFactor(0.25)
						.lineLimit(1)
						.foregroundColor(viewModel.textColor)
						.shadow(color: viewModel.textColor, radius: isAnimating ? 2 : viewModel.textShadowRadius, x: 0, y: 0)
						.layoutPriority(2)
						.padding()
				} else  {
					Divider()
						.padding([.leading, .trailing])
				}
				arrowImage(.right)
			}
			.scaleEffect(isAnimating ? 2 : 1)
			.frame(width: viewModel.panelWidth * 2)
			.fixedSize()
			
			HStack {
				if serviceSide == .right || serviceSide == nil  {
					Spacer()
				}
				
				Circle()
					.foregroundColor(viewModel.textColor)
					.shadow(color: isMovingBall ? .white : viewModel.ballColor, radius: viewModel.ballShadowRadius, x: isMovingBall ? viewModel.ballMovingShadowSize.width : viewModel.ballShadowSize.width, y: isMovingBall ? viewModel.ballMovingShadowSize.height : viewModel.ballShadowSize.height)
					.padding([.top])
					.scaledToFit()
					.offset(x: 0, y: isAnimating ? screenHeight : 0)
				
				if serviceSide == .left || serviceSide == nil  {
					Spacer()
				}
			}
			.frame(height: isAnimating ? screenHeight/8 : screenHeight/10)
			.padding([.top])
		}
		.padding()
		.onChange(of: viewModel.match.status) { newValue in
			switch newValue {
			case .ping:
				withAnimation(.easeInOut(duration: 1)) {
					isAnimating = true
					withAnimation(.linear(duration: 1).repeatForever()) {
						blink = true
					}
				}
			default:
				if isAnimating {
					withAnimation(.easeInOut) {
						isAnimating = false
						blink = false
					}
				}
			}
		}
		
		.onChange(of: viewModel.match.game.service) { newValue in
			let moveDuration = serviceSide == nil ? 0.5 : 1.0
			withAnimation(.easeOut(duration: moveDuration)) {
				serviceSide = viewModel.match.serviceSide
				isMovingBall = true
			}
			withAnimation(.linear(duration: 1).delay(moveDuration)) {
				isAnimatingBallShadow = true
				isMovingBall = false 
			}
		}
		
	}
	
	func arrowImage(_ tableSide: TableSide) -> some View {
		return Image(systemName: viewModel.imageName(tableSide))
			.resizable()
			.scaledToFit()
			.foregroundColor(viewModel.imageColor(tableSide))
			.opacity(blink ? 0.25 : 1)
			.shadow(color: .green, radius: isAnimating ? 8 : (blink ? 0 : viewModel.arrowShadowRadius(tableSide)), x: 0, y: 0)
			.padding(tableSide == .left ? .trailing : .leading)
	}

}

struct ServiceView_Previews: PreviewProvider {
	static var previews: some View {
		ServiceView(viewModel: ServiceVM(Match(), panelWidth: 200))
	}
}
