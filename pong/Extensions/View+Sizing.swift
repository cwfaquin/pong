//
//  View+Size.swift
//  View+Size
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

extension View {
	func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
		background(
			GeometryReader { geoProxy in
				Color.clear
					.preference(key: SizeKey.self, value: geoProxy.size)
			}
		)
		.onPreferenceChange(SizeKey.self, perform: onChange)
	}
}

extension GeometryProxy {
	func middleWidth() -> CGFloat {
		max(size.width/6, 100)
	}
}
