//
//  FlicRow.swift
//  pong
//
//  Created by Charles Faquin on 10/3/21.
//

import SwiftUI
import flic2lib

struct FlicRow: View {
	
	@Binding var button: FLICButton
	@State var selectedName: FlicName
	
	let segmentHeight: CGFloat = 50
	
	var body: some View {
		VStack {
			HStack {
				Text(button.name ?? button.uuid)
					.bold()
					.padding(.trailing)
				Text(button.state.description)
					.italic()
					.foregroundColor(.gray)
				Spacer()
				Button(action: rightButtonTapped) {
					Text(button.state == .connected ? "Disconnect" : "Forget")
						.foregroundColor(button.isReady ? .green : .pink)
				}
			}
			GroupBox(content: {
				Divider()
				HStack {
					Picker("Button Role", selection: $selectedName) {
						ForEach(FlicName.allCases) { name in
							Image(systemName: name.imageName)
								.resizable()
								.tag(name)
								.accentColor(selectedName == name ? .black : .white)
						}
					}
					.disabled(button.state == .connected)
					.pickerStyle(SegmentedPickerStyle())
					.frame(minWidth: segmentHeight * 3, idealWidth: segmentHeight * 6, maxWidth: UIScreen.main.bounds.width * 0.4, minHeight: 40, idealHeight: segmentHeight, maxHeight: segmentHeight * 2)
				}
			}, label: {
				Label(selectedName.description, systemImage: button.pongName == .unassigned ? "exclamationmark" : "checkmark")
					.foregroundColor(button.pongName == .unassigned || !button.isReady ? .orange : .green)
					.accentColor(button.pongName == .unassigned || !button.isReady ? .orange : .green)
					.frame(alignment: .leading)
			})
				.groupBoxStyle(BlackGroupBoxStyle())
		}
		.padding()
		.onChange(of: selectedName) { newValue in
			button.nickname = newValue.rawValue
		}
	}

	func rightButtonTapped() {
		if button.isReady {
			button.disconnect()
		} else {
			FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
				if let error = error {
					print("Failed to forget button with error: \(error.localizedDescription).")
				}
			})
		}
	}
}

struct FlicDevice: Identifiable {
	var pongName: FlicName?
	var id: String
	var message: String?
	
}

struct FlicRow_Previews: PreviewProvider {
	static var previews: some View {
		FlicRow(button: .constant(FLICButton()), selectedName: .unassigned)
	}
}
