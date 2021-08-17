//
//  ScoreboardVM.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Combine
import SwiftUI
import flic2lib

final class ScoreboardVM: NSObject, ObservableObject {
			
	

	override init() {
		super.init()
		FLICManager.configure(with: self, buttonDelegate: self, background: true)
	}
	
}

extension ScoreboardVM: FLICManagerDelegate {
	func managerDidRestoreState(_ manager: FLICManager) {
		print(#function)
		print(String(describing: manager))
	}
	
	func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
		print(#function)
		print(String(describing: state))
	}
}

extension ScoreboardVM: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		print(String(describing: button))
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		print(String(describing: button))
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		print(String(describing: button))
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		print(String(describing: button))
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		print("nickname = \(nickname)")
		print(String(describing: button))
	}
	
	func button(_ button: FLICButton, didUpdateBatteryVoltage voltage: Float) {
		print(#function)
		print(String(describing: button))
		print("voltage = \(voltage)")
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		print(String(describing: button))
		print(String(describing: error))
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		print(String(describing: button))
		print(String(describing: error))
	}
	
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		print(String(describing: button))
		print(String(describing: error))
	}
	
}
