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
	@Binding var message: String?
	
	let segmentHeight: CGFloat = 50
	
	var body: some View {
		VStack {
		HStack {
			VStack(alignment: .leading) {
				HStack {
					Text(button.name ?? button.uuid)
						.bold()
						.foregroundColor(stateColor)
						.padding(.trailing)
					Text(button.state.description)
						.italic()
						.foregroundColor(.gray)
				}
				GroupBox {
					Label(selectedName.description, systemImage: buttonUnassigned ? "xmark.circle" : "checkmark.circle")
						.foregroundColor(buttonUnassigned ? .orange : .green)
						.accentColor(buttonUnassigned ? .orange : .green)
						.frame(alignment: .leading)
					Divider()
					HStack {
						Picker("Button Role", selection: $selectedName) {
							ForEach(FlicName.allCases) { name in
								Image(systemName: name.imageName)
									.resizable()
									.tag(name)
									.foregroundColor(button.isReady ? Color(UIColor.cyan) : .gray)
							}
						}
						.pickerStyle(SegmentedPickerStyle())
						.frame(minWidth: segmentHeight * 3, idealWidth: segmentHeight * 6, maxWidth: UIScreen.main.bounds.width * 0.4, minHeight: 40, idealHeight: segmentHeight, maxHeight: segmentHeight * 2)
					}
				}
					.disabled(!button.isReady)
					.groupBoxStyle(BlackGroupBoxStyle())
					.cornerRadius(10)
			}
			.padding()
			Spacer()
			VStack {
					Button(action: rightButtonTapped) {
						Text(rightButtonText)
							.font(.body)
							.foregroundColor(Color(UIColor.cyan))
							.padding()
							.background(
								Color(UIColor.systemGray6)
									.cornerRadius(10)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 10, style: .continuous)
									.stroke(Color(UIColor.cyan), lineWidth: 1)
								)
					}
					.disabled(rightButtonDisabled)
					.padding()
					
					Button(action: forgetButton) {
						Text("Forget")
							.font(.body)
							.foregroundColor(.pink)
							.padding()
							.background(
								Color(UIColor.systemGray6)
									.cornerRadius(10)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 10, style: .continuous)
									.stroke(Color(UIColor.systemPink), lineWidth: 1)
								)
					}
					.padding()
			}
			.padding()
		}
			if let message = message {
				Divider()
				Text(message)
					.padding()
			}
			
		}
		.onChange(of: selectedName) { newValue in
			button.nickname = newValue.rawValue
			print(button.pongName)
		}
		.onAppear {
			switch button.state {
			case .connecting:
				message = "TIP: While in 'Connecting' mode, tap FlicButton to connect."
			default:
				break
			}
		}
	}
	
	var buttonUnassigned: Bool {
		selectedName == .unassigned
	}
	
	
	var stateColor: Color {
		switch button.state {
		case .connected:
			return .green
		default:
			return .orange
		}
	}
	
	func rightButtonTapped() {
		switch button.state {
		case .connected:
			button.disconnect()
		case .disconnected:
			button.connect()
		default:
			break
		}
	}
	
	func forgetButton() {
		FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
			if let error = error {
				print("Failed to forget button with error: \(error.localizedDescription).")
			}
		})
	}
	
	
	var rightButtonText: String {
		switch button.state {
		case .connected, .disconnecting:
			return "Disconnect"
		default:
			return "Connect"
		}
	}
	
	var rightButtonDisabled: Bool {
		switch button.state {
		case .connected, .disconnected:
			return false
		default:
			return true
		}
	}
}


struct FlicRow_Previews: PreviewProvider {
	static var previews: some View {
		FlicRow(button: .constant(FLICButton()), selectedName: .unassigned, message: .constant(nil))
	}
}
