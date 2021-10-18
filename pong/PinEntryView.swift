//
//  PinEntryView.swift
//  pong
//
//  Created by Charles Faquin on 10/17/21.
//

import SwiftUI

struct PinEntryView: View {
	
	let pin: String
	@State var confirmPin: String = ""
	@State var tryAgain: Bool = false
	@Binding var didCancel: Bool
	@Binding var didSucceed: Bool
	@Environment(\.presentationMode) private var presentationMode
	
    var body: some View {
		
				VStack {
				SecureField("4 Digit PIN", text: $confirmPin)
					.multilineTextAlignment(.center)
					.keyboardType(.numberPad)
					.textContentType(.newPassword)
					.font(.headline)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding()
					.border(Color.pink, width: 1)
					.cornerRadius(10)
					.padding()
					
					Button("Cancel") {
						didCancel = true
						presentationMode.wrappedValue.dismiss()
					}
						.buttonStyle(RoundedRectangleButtonStyle())
						.padding()
				}
				.background(Color.black.opacity(0.8))
			.onChange(of: confirmPin) { newValue in
				guard newValue.count > 3 else { return }
				if confirmPin == pin {
					didSucceed = true 
					presentationMode.wrappedValue.dismiss()
				} else {
					confirmPin = ""
					tryAgain = true
				}
			}
    }
}

struct PinEntryView_Previews: PreviewProvider {
    static var previews: some View {
			PinEntryView(pin: "1234", didCancel: .constant(false), didSucceed: .constant(false))
    }
}
