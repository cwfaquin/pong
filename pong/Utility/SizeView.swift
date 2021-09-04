//
//  SizeView.swift
//  SizeView
//
//  Created by Charles Faquin on 8/31/21.
//

import SwiftUI

struct SizeView: View {
	
	typealias Key = SizeKey
	
	var body: some View {
		GeometryReader { geo in
			Color.clear
				.anchorPreference(key: Key.self, value: .bounds) { anchor in
					geo.size
				}
		}
	}
}

struct SizeView_Previews: PreviewProvider {
	static var previews: some View {
		SizeView()
	}
}
