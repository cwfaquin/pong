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
			
	//@Published var rightButtonVM: ButtonVM
	@Published var singleTap: TableSide?
	@Published var doubleTap: TableSide?
	@Published var leftButton: FLICButton?
	@Published var rightButton: FLICButton?
	@Published var homeButton: FLICButton?
	@Published var buttonManagerReady: Bool = false 
			
	func scanForButtons() {
		FLICManager.shared()?.scanForButtons(stateChangeHandler: { statusEvent in
			switch statusEvent {
			case .discovered:
				print("Flic button discovered")
			case .connected:
				print("Flic button connected and is verifying.")
			case .verified:
				print("Flic button verified.")
			case .verificationFailed:
				print("Flic button verification failed.")
			default:
				print("Scanning")
			}
		}, completion: { button, error in
			guard let button = button else {
				print(error?.localizedDescription ?? "Try scanning again")
				return
			}
			if let nickname = button.nickname {
				switch FlicName(rawValue: nickname) {
				case .tableLeft:
					self.leftButton = button
				case .tableRight:
					self.rightButton = button
				case .home:
					self.homeButton = button
				default:
					print("Unassigned Button")
				}
			}
			button.triggerMode = .clickAndDoubleClick
			button.connect()
		})
	}
}

extension ScoreboardVM: FLICManagerDelegate {
	func managerDidRestoreState(_ manager: FLICManager) {
		print(#function)
		scanForButtons()
	}
	
	func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
		print(#function)
		print(state.description)
	}
}

extension ScoreboardVM: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		print(button.nickname ?? button.uuid)
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button nickname: \(button.nickname ?? "")")
		}
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		print(button.nickname ?? button.uuid)
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button is Ready")
		}
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		switch FlicName(rawValue: nickname) {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button nickname: \(nickname)")
		}
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		switch button {
		case leftButton:
			singleTap = .left
			playSound(.singleTapSide)
		case rightButton:
			singleTap = .right
			playSound(.singleTapSide)
		case homeButton:
			singleTap = nil
			playSound(.singleTapMiddle)
		default:
			playSound(.button1)
			assertionFailure("Unnamed Button clicked")
			return
		}
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		switch button {
		case leftButton:
			doubleTap = .left
		case rightButton:
			doubleTap = .right
		case homeButton:
			doubleTap = nil
		default:
			playSound(.button1)
			assertionFailure("Unnamed Button double clicked")
			return
		}
		playSound(.doubleTap)
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button error.")
		}
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button error.")
		}
	}
	
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		switch FlicName(rawValue: button.nickname ?? "") {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button error.")
		}
	}
}

extension ScoreboardVM {
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
