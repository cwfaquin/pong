//
//  ScoreView.swift
//  ScoreView
//
//  Created by Charles Faquin on 8/22/21.
//

import SwiftUI

struct ScoreView: View {
	
	@State var score: String
	
	var body: some View {
		GroupBox {
			Text(score)
				.font(.largeTitle)

		}
	}
}

struct ScoreView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreView(score: "0")
	}
}
