//
//  ButtonsView.swift
//  pong
//
//  Created by Charles Faquin on 10/2/21.
//

import SwiftUI
import flic2lib

struct ButtonsView: View {
	
	@EnvironmentObject var buttonManager: PongAppVM
	
	var body: some View {
		Form {
			Section(header: Text("Flic Buttons".spaced)) {
				HStack {
					if buttonManager.isScanning {
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle())
							.padding(.trailing)
					}
					Text(buttonManager.message)
					Spacer()
					Button(action: buttonManager.scanForButtons) {
						Text(buttonManager.isScanning ? "Stop" : "Scan")
							.foregroundColor(buttonManager.isScanning ? .pink : Color(UIColor.cyan))
							.buttonStyle(RoundedRectangleButtonStyle())
						
					}
				}
				.groupBoxStyle(BlackGroupBoxStyle())
				.cornerRadius(10)
			}
			
			ForEach(buttonManager.pairedButtons, id: \.id) { button in
				Section {
				FlicRow(
					button: .init(
						get: { button },
						set: { buttonManager.updatePaired($0) }
					),
					selectedName: button.pongName,
					message: $buttonManager.buttonDict[button.identifier]
				)
				}
			}
			Section {
			Button("Dismsiss", action: { buttonManager.scanViewVisible.toggle() })
				.buttonStyle(RoundedRectangleButtonStyle())
				.padding()
			}
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct ButtonsView_Previews: PreviewProvider {
	static var previews: some View {
		ButtonsView()
			.environmentObject(PongAppVM())
	}
}
