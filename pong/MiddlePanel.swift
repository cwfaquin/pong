//
//  MiddlePanel.swift
//  MiddlePanel
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI

struct MiddlePanel: View {
    var body: some View {
			
			GeometryReader { geo in
				
				LazyVStack {
					Rectangle()
						.frame(width: geo.size.width, height: geo.size.height * 0.2)
					Text("SET")
						.frame(width: geo.size.width, height: geo.size.height * 0.1)
					Text("MATCH")
						.frame(width: geo.size.width, height: geo.size.height * 0.1)
					Rectangle()
						.frame(width: geo.size.width, height: geo.size.height * 0.5)
					}
				.onAppear {
					print(geo, word: "MIDDLE PANEL")

				}
			}
		}
}

struct MiddlePanel_Previews: PreviewProvider {
    static var previews: some View {
        MiddlePanel()
    }
}


func print(_ geo: GeometryProxy, word: String) {
	DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
		print(word)
		print("geo = \(geo.size)")
		print("safe = \(geo.safeAreaInsets)")
		print("geoFrameLocal = \(geo.frame(in: .local))")
		print("geoFrameGlobal = \(geo.frame(in: .global))")

		print("screen = \(UIScreen.main.bounds)")
	}
}
