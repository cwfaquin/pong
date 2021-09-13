//
//  CircleLineView.swift
//  CircleLineView
//
//  Created by Charles Faquin on 9/11/21.
//

import SwiftUI

struct CircleLineView: View {
	
	let screenHeight = UIScreen.main.bounds.height
	let screenWidth = UIScreen.main.bounds.width
	@Binding var isAnimating: Bool
	@State var tableSide: TableSide = .right
	
	var serveSpaceWidth: CGFloat {
		screenWidth * 0.15
	}
	
	var leftSpacer: some View {
		switch tableSide {
		case .left:
			return Spacer(minLength: serveSpaceWidth)
		case .right:
			return Spacer()
		}
	}
	
	var rightSpacer: some View {
		switch tableSide {
		case .right:
			return Spacer(minLength: serveSpaceWidth)
		case .left:
			return Spacer()
		}
	}
	
	var leftOrigin: CGPoint {
		CGPoint(x: serveSpaceWidth, y: 11)
	}
	
	var rightOrigin: CGPoint {
		CGPoint(x: screenWidth - serveSpaceWidth - screenWidth/5, y: 11)
	}
	
	var origin: CGPoint {
		switch tableSide {
		case .left:
			return leftOrigin
		case .right:
			return rightOrigin
		}
	}
	
	var body: some View {
				CircleLineShape()
					.stroke(
						style: StrokeStyle(lineWidth: screenHeight/20, lineCap: .round, lineJoin: .round)
					)
					.path(in: CGRect(origin: tableSide == .left ? leftOrigin : rightOrigin, size: CGSize(width: screenWidth/5, height: screenHeight/15)))
					.foregroundColor(.green)
					.shadow(color: .green, radius: 10, x: 0, y: 0)
		
		
	}
}

struct CircleLineView_Previews: PreviewProvider {
	static var previews: some View {
		CircleLineView(isAnimating: .constant(false), tableSide: .right)
	}
}
struct CircleLineShape: Shape {
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.minX, y: rect.midY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
		return path
	}

}


struct Arrows: View {
	private let arrowCount = 3
	
	let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
	
	@State var scale:CGFloat = 1.0
	@State var fade:Double = 0.5
	
	var body: some View {
		
			HStack{
				ForEach(0..<self.arrowCount) { i in
					Rectangle()
						.stroke(style: StrokeStyle(lineWidth: CGFloat(10),
																			 lineCap: .round,
																			 lineJoin: .round ))
						.foregroundColor(Color.white)
						.aspectRatio(CGSize(width: 28, height: 70), contentMode: .fit)
						.frame(maxWidth: 20)
						.animation(nil)
						.opacity(self.fade)
						.scaleEffect(self.scale)
						.animation(
							.easeOut(duration: 0.5)
							//.repeatForever(autoreverses: true)
								.repeatCount(1, autoreverses: true)
								.delay(0.2 * Double(i))
						)
				}.onReceive(self.timer) { _ in
					self.scale = self.scale > 1 ?  1 : 1.2
					self.fade = self.fade > 0.5 ? 0.5 : 1.0
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						self.scale = 1
						self.fade = 0.5
					}
				}
			}
		}
	
}
