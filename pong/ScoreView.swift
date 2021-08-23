//
//  ScoreView.swift
//  ScoreView
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

struct ScoreView: View {
	
	@State var imageName: String
	
	var body: some View {
		
		Image(systemName: imageName)
			.resizable()
			.foregroundColor(.white)
			.aspectRatio(contentMode: .fit)
			.padding()
	}
}

struct ScoreView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreView(imageName: "zero.circle")
	}
}
