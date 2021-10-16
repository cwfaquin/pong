//
//  ButtonStyle.swift
//  ButtonStyle
//
//  Created by Charles Faquin on 9/7/21.
//

import SwiftUI

// The button action triggers on double taps.
struct DoubleTapStyle: PrimitiveButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button(configuration) // <- Button instead of configuration.label
			.onTapGesture(count: 2, perform: configuration.trigger)
	}
}

struct RoundedRectangleButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			Spacer()
			configuration.label.foregroundColor(Color(UIColor.cyan))
			Spacer()
		}
		.padding()
		.background(Color.black.cornerRadius(8))
		.scaleEffect(configuration.isPressed ? 0.95 : 1)
	}
}

