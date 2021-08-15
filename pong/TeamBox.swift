//
//  TeamBox.swift
//  TeamBox
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI

struct TeamBox: View {
    var body: some View {
			Spacer()
		/*	LazyVGrid(columns: [.init(), .init()]) {
				ForEach(1...2) { _ in
													GroupBox(
															label: Label("Heart Rate", systemImage: "heart.fill")
																	.foregroundColor(.red)
													) {
															Text("Your hear rate is 90 BPM.")
													}
											}
									}.padding()*/
    }
}

struct TeamBox_Previews: PreviewProvider {
    static var previews: some View {
        TeamBox()
    }
}
