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
					.preference(key: PreferenceKeySize.self, value: geoProxy.size)
			}
		)
		.onPreferenceChange(PreferenceKeySize.self, perform: onChange)
	}
}
