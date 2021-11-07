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
	
    var body: some View {
		
				VStack {
					Text("Enter PIN to delete")
						.font(.title2)
				SecureField("4 Digit PIN", text: $confirmPin)
					.multilineTextAlignment(.center)
					.keyboardType(.numberPad)
					.textContentType(.newPassword)
					.font(.title2)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding([.leading, .trailing, .bottom])
		
					Button(action: { didCancel = true }) {
						Text("Cancel")
							.font(.title3)
							.foregroundColor(.black)
							.padding()
							.background(Color(UIColor.cyan))
							.cornerRadius(10)
					}
					.padding()
				}
				.padding()
			.onChange(of: confirmPin) { newValue in
				guard newValue.count > 3 else { return }
				if confirmPin == pin {
					didSucceed = true 
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
