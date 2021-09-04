//
//  DeviceOrientationModifier.swift
//  DeviceOrientationModifier
//
//  Created by Charles Faquin on 9/2/21.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
		let action: (UIDeviceOrientation) -> Void

		func body(content: Content) -> some View {
				content
						.onAppear()
						.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
								action(UIDevice.current.orientation)
						}
		}
}

// A View wrapper to make the modifier easier to use
extension View {
		func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
				modifier(DeviceRotationViewModifier(action: action))
		}
}
