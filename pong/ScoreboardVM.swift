//
//  ScoreboardVM.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Combine
import SwiftUI
import flic2lib
import AudioToolbox

final class ScoreboardVM: NSObject, ObservableObject {
			
	@Published var match: Match = Match()
	@Published var home: Team = Team(.home)
	@Published var guest: Team = Team(.guest)
	
	override init() {
		super.init()
		FLICManager.configure(with: self, buttonDelegate: self, background: true)
	}
	
	func playSound(_ soundType: ScoreboardVM.SoundType) {
		var soundID: SystemSoundID = 0
		guard let path = Bundle.main.path(forResource: soundType.rawValue, ofType: "mp3")  else {
			assertionFailure("Failed to find file at: \(soundType.rawValue)")
			return
		}
		let url = NSURL(fileURLWithPath: path)
		AudioServicesCreateSystemSoundID(url, &soundID)
		AudioServicesPlaySystemSound(soundID)
	}
	
	enum SoundType: String, CaseIterable {
		case button1 //tiny swoosh
		case singleTapMiddle = "button2" //tiny beep
		case doubleTap = "button3" //remove point
		case singleTapSide = "button4" //snap

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
		print(button.nickname ?? button.uuid)
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		print(button.nickname ?? button.uuid)
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		print(String(describing: button))
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			playSound(.singleTapSide)
			match.singleTap(.left)
		case .tableRight:
			playSound(.singleTapSide)
			match.singleTap(.right)
		case .home:
			playSound(.singleTapMiddle)
			match.singleTapMiddle()
		default:
			assertionFailure("Unnamed Button clicked")
		}
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		playSound(.doubleTap)
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			match.doubleTap(.left)
		case .tableRight:
			match.doubleTap(.right)
		case .home:
			match.singleTapMiddle()
		default:
			assertionFailure("Unnamed Button clicked")
		}
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		print("nickname = \(nickname)")
	}
	
	func button(_ button: FLICButton, didUpdateBatteryVoltage voltage: Float) {
		print(#function)
		print("voltage = \(voltage)")
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		print(String(describing: error))
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
	}
	
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
	}
	
}
