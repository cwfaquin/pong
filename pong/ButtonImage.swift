//
//  ButtonImage.swift
//  ButtonImage
//
//  Created by Charles Faquin on 8/23/21.
//

import SwiftUI

struct ButtonImage: View {
	
	let systemName: String
	
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		
		Image(systemName: systemName)
			.resizable()
			.frame(width: notMacApp ? 40 : 50, height: notMacApp ? 40 : 50)
			.foregroundColor(.pink)
			.shadow(color: .pink, radius: 4, x: 0, y: 0)
	}
}

struct ButtonImage_Previews: PreviewProvider {
	static var previews: some View {
		ButtonImage(systemName: "gear")
	}
}
