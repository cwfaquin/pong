//
//  SeriesScoreView.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import SwiftUI

struct SeriesScoreView: View {
	
	@Binding var viewModels: [CircleScoreVM]

	var body: some View {
		
		HStack(alignment: .center, spacing: 20) {
			ForEach(viewModels, id: \.id) {
				Image(systemName: $0.systemName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor($0.color)
					.shadow(color: $0.color, radius: $0.shadowRadius, x: 0, y: 0)
					.padding()
					.animation(.spring())
			}
		}.animation(.spring())
	}
	
}

struct SeriesScoreView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModels = Array(0...3).compactMap { CircleScoreVM(index: $0, systemName: "circle", color: Color(UIColor.cyan), shadowRadius: 5) }
		SeriesScoreView(viewModels: .constant(viewModels))
	}
}

struct CircleScoreVM: Identifiable {
	let index: Int
	let systemName: String
	let color: Color
	let shadowRadius: CGFloat
	
	var id: Int {
		index
	}
}
