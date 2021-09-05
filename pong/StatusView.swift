//
//  StatusView.swift
//  StatusView
//
//  Created by Charles Faquin on 9/5/21.
//

import SwiftUI
import AudioToolbox

struct StatusView: View {
	
	@Binding var statusText: String

    var body: some View {
			GroupBox {
				Text(statusText)
					.font(.system(size: 50, weight: .regular, design: .monospaced))
					.foregroundColor(._teal)
					.shadow(color: ._teal, radius: 1, x: 0, y: 0)
					.fixedSize(horizontal: false, vertical: false)
					.padding()
			}
			.padding()
				.groupBoxStyle(BlackGroupBoxStyle(color: .clear))
				.background(Color.black.opacity(0.9))
				.cornerRadius(12)
				.overlay(
					RoundedRectangle(cornerRadius: 12)
						.stroke(.blue, lineWidth: 4)
						.shadow(color: .blue, radius: 2, x: 0, y: 0)
				)
    }
	

}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
			StatusView(statusText: .constant("Game on!"))
    }
}
