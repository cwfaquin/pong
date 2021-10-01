//
//  PossessionArrow.swift
//  PossessionArrow
//
//  Created by Charles Faquin on 8/16/21.
//

import SwiftUI

struct ServiceView: View {
	
	@State var isAnimating = false
	@State var isPulsing = false
	@ObservedObject var viewModel: ServiceVM
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	@State var blink = false
	@State var serviceSide: TableSide?
	
	var notMacApp: Bool {
		screenWidth <= 1024
	}
	
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
			.frame(width: notMacApp ? viewModel.panelWidth * 2 : viewModel.panelWidth * 2.5)
			.fixedSize()
			HStack {
				if let serviceSide = serviceSide {
					if serviceSide == .right {
						Spacer()
					}
					Circle()
						.fill(Color.green)
						.shadow(color: .green, radius: 15, x: 0, y: 0)
						.scaleEffect(isPulsing ? 0.9 : 1.0)
						.frame(width: screenHeight/15, height: screenHeight/15)
						.padding()
					
					if serviceSide == .left {
						Spacer()
					}
				}
			}
			.fixedSize(horizontal: false, vertical: true)
			.frame(height: isAnimating ? (notMacApp ? screenHeight/8 : screenHeight/4) : (notMacApp ? screenHeight/12 : screenHeight/7))
		}
		.padding()
		.onChange(of: viewModel.match.status) { newValue in
			handlePingAnimation()
			updateServiceSide()
		}
		.onChange(of: viewModel.match.game.service) { newValue in
			updateServiceSide()
		}
	}
	
	func updateServiceSide() {
		withAnimation(.easeOut(duration: 1)) {
			switch viewModel.match.status {
			case .playing:
				serviceSide = viewModel.match.serviceSide
				withAnimation(.linear(duration: 1.5).repeatForever()) {
					isPulsing = true
				}
			default:
				serviceSide = nil
				isPulsing = false
			}
		}
	}
	
	func handlePingAnimation() {
		switch viewModel.match.status {
		case .ping:
			withAnimation(.easeInOut(duration: 1).delay(1.5)) {
				isAnimating = true
				withAnimation(.easeOut(duration: 1.2).repeatForever().delay(1.5)) {
					blink = true
				}
			}
		default:
			withAnimation(.easeInOut) {
				isAnimating = false
				blink = false
			}
		}
	}
	
	func arrowImage(_ tableSide: TableSide) -> some View {
		return Image(systemName: viewModel.imageName(tableSide))
			.resizable()
			.scaledToFit()
			.foregroundColor(viewModel.imageColor(tableSide))
			.opacity(blink ? 0.1 : 1)
			.shadow(color: .green, radius: isAnimating ? 8 : (blink ? 0 : viewModel.arrowShadowRadius(tableSide)), x: 0, y: 0)
			.padding(tableSide == .left ? .trailing : .leading)
	}
	
}

struct ServiceView_Previews: PreviewProvider {
	static var previews: some View {
		ServiceView(viewModel: ServiceVM(Match(), panelWidth: 200))
	}
}
