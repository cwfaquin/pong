//
//  ButtonImage.swift
//  ButtonImage
//
//  Created by Charles Faquin on 8/23/21.
//

import SwiftUI

struct ButtonImage: View {
	
	let systemName: String
	
    var body: some View {
				Image(systemName: systemName)
					.imageScale(.large)
					.foregroundColor(.pink)
					.shadow(color: .pink, radius: 4, x: 0, y: 0)
					.padding()
    }
}

struct ButtonImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonImage(systemName: "gear")
    }
}
