//
//  StatusView.swift
//  StatusView
//
//  Created by Charles Faquin on 9/5/21.
//

import SwiftUI
import AudioToolbox

struct StatusView: View {
	
	@Binding var showStatus: Bool
	@Binding var viewModel: StatusVM

    var body: some View {
			GroupBox {
				Text(viewModel.text)
					.font(.system(size: 50, weight: .regular, design: .monospaced))
					.foregroundColor(._teal)
					.shadow(color: ._teal, radius: 2, x: 0, y: 0)
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
			.onAppear {
				checkAutoDismiss()
			}
			.onChange(of: viewModel) {_ in
				checkAutoDismiss()
			}
    }
	
	func checkAutoDismiss() {
		guard viewModel.temporary else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			showStatus = false
		}
	}
	

}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
			StatusView(showStatus: .constant(true), viewModel: .constant(StatusVM(text: "Game On!", temporary: false)))
    }
}

struct StatusVM: Identifiable, Equatable {
	let text: String
	let temporary: Bool
	var id: String { text }
}
