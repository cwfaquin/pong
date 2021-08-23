//
//  ScoresView.swift
//  ScoresView
//
//  Created by Charles Faquin on 8/23/21.
//

import SwiftUI

struct ScoresView: View {
	
	@ObservedObject var viewModel: ScoresVM
	@State var serviceWidth: CGFloat = 0

    var body: some View {
			HStack {
				ScoreView(imageName: viewModel.imageName(.left))
				ServiceView(viewModel: ServiceVM(viewModel.match))
				ScoreView(imageName: viewModel.imageName(.right))
			}.fixedSize(horizontal: true, vertical: false)
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
			ScoresView(viewModel: ScoresVM(Match()))
    }
}
