//
//  BlackGroupBoxStyle.swift
//  BlackGroupBoxStyle
//
//  Created by Charles Faquin on 8/16/21.
//

import SwiftUI

struct BlackGroupBoxStyle: GroupBoxStyle {
	
	let color: Color
	
	init(color: Color = .black) {
		self.color = color
	}
	func makeBody(configuration: Configuration) -> some View {
		VStack {
				configuration.label
				configuration.content
		}
		.padding()
		.background(color)
		//.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
	}
}
