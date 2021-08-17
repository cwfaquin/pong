//
//  SettingsView.swift
//  SettingsView
//
//  Created by Charles Faquin on 8/15/21.
//

import SwiftUI
import flic2lib

struct SettingsView: View {
	
	let flicButtons = [0, 1, 2]
    var body: some View {
			Form {
				Section(header: Label("Flic Buttons", image: "dot.radiowaves.left.and.right")) {
					ForEach(0..<flicButtons.count) { i in
						HStack {
							Text("Button \(i)")
							ProgressView()
								.progressViewStyle(.circular)
								
						}
					}
				}
			}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
