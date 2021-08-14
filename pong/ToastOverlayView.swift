//
//  ToastOverlayView.swift
//  pong
//
//  Created by Charles Faquin on 8/14/21.
//

import SwiftUI

struct ToastOverlayView: View {
	@Binding var isShowing : Bool
	@Binding var curColor : Color
	
	let colors: [Color] = [.blue, .red, .green, .yellow]
	
	var body: some View {
		ZStack {
			ForEach(1...colors.count, id: \.self) { item in
				Circle()
					.trim(from: isShowing ? CGFloat(item) * 0.25 - 0.25 : CGFloat(item) * 0.25,
								to: CGFloat(item) * 0.25)
					.stroke(colors[item - 1], lineWidth: 30)
					.frame(width: 300, height: 300)
					.animation(.linear(duration: 0.4))
					.onTapGesture {
						curColor = colors[item - 1]
						isShowing.toggle()
					}
			}
		}
		.opacity(isShowing ? 1 : 0)
		.rotationEffect(.degrees(isShowing ? 0 : 180))
		.animation(.linear(duration: 0.5))
	}
	
}
