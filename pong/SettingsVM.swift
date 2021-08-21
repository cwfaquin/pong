//
//  SettingsVM.swift
//  SettingsVM
//
//  Created by Charles Faquin on 8/17/21.
//

import Foundation
import flic2lib

final class SettingsVM: ObservableObject {
	
	@Published var isScanning: Bool = false
	@Published var leftButton: FLICButton?
	@Published var rightButton: FLICButton?
	@Published var homeButton: FLICButton?

	

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
				print("Flic button unknown state.")
			}
		}, completion: { button, error in
			self.isScanning = false
			guard let button = button else {
				print("Scanner completed with error: \(error.debugDescription)")
				return
			}
			
			print("Flic button successfully verified.\nName = \(button.name ?? "")\nbluetooth address = \(button.bluetoothAddress))\nserial# = \(button.serialNumber)\nnickname = \(button.nickname ?? "")")
			button.triggerMode = .clickAndDoubleClick
			print("Set Nickname")
		})
	}
	
	func removeButton(_ nickname: FlicName) {
		guard let button = FLICManager.shared()?.buttons().first(where: {$0.nickname == nickname.rawValue}) else {
			assertionFailure("Button is already removed")
			return
		}
		FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
			guard let error = error else {
				print("Succeessfully removed button with uuid: \(uuid)")
				return
			}
			print("Failed to forget button \(uuid) with error: \(error.localizedDescription)")
		})
	}
	
	func flicButton(_ name: FlicName) -> FLICButton?  {
		switch name {
		case .tableLeft:
			return leftButton
		case .tableRight:
			return rightButton
		case .home:
			return homeButton
		}
	}
	
	var needsScan: Bool {
		leftButton == nil || rightButton == nil || homeButton == nil 
	}
}

extension FLICButtonState {
	var description: String {
		switch self {
		case .connected:
			return "Connected"
		case .disconnected:
			return "Disconnected"
		case .disconnecting:
			return "Disconnecting"
		case .connecting:
			return "Connecting"
		default:
			return "Status Unknown"
		}
	}
}

enum FlicName: String, CaseIterable {
	case home
	case tableLeft = "Table Left"
	case tableRight = "Table Right"
	
	var singleSound: ScoreboardVM.SoundType {
		switch self {
		case .home:
			return .singleTapMiddle
		default:
			return .singleTapSide
		}
	}
	
	var doubleSound: ScoreboardVM.SoundType {
		.doubleTap
	}
}
