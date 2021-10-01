//
//  ButtonManager.swift
//  pong
//
//  Created by Charles Faquin on 9/30/21.
//

import Foundation
import flic2lib
import SwiftUI

protocol ButtonContract {
	func singleClick(_ tableSide: TableSide?)
	func doubleClick(_ tableSide: TableSide?)
	func longPress(_ tableSide: TableSide?)
}

final class ButtonManager: NSObject, ObservableObject {
	
	@Published var isScanning: Bool = false
	@Published var buttonsFound: [FLICButton] = []
	@Published var scanStatus: String = ""
	
	var contract: ButtonContract?
	
	override init() {
		buttonsFound = FLICManager.shared()?.buttons() ?? []
	}

	func configure(_ contract: ButtonContract) {
		self.contract = contract
		FLICManager.configure(with: self, buttonDelegate: self, background: false)
	}
	
	var allButtonsFound: Bool {
		(FLICManager.shared()?.buttons() ?? []).count == FlicName.allCases.count
	}

	func scanForButtons() {
		scanStatus = "Scanning"
		isScanning = true
		FLICManager.shared()?.scanForButtons(stateChangeHandler: { statusEvent in
			switch statusEvent {
			case .discovered:
				self.scanStatus = "Flic button discovered"
			case .connected:
				self.scanStatus = "Flic button connected and is verifying."
			case .verified:
				self.scanStatus = "Flic button verified."
			case .verificationFailed:
				self.scanStatus = "Flic button verification failed."
			default:
				self.scanStatus = "Scanning"
			}
		}, completion: { button, error in
			self.isScanning = false
			guard let button = button else {
				print("Scanner completed with error: \(error.debugDescription)")
				return
			}
			
			print("Flic button successfully verified.\nName = \(button.name ?? "")\nbluetooth address = \(button.bluetoothAddress))\nserial# = \(button.serialNumber)\nnickname = \(button.nickname ?? "")")
			button.triggerMode = .clickAndDoubleClick
			self.buttonsFound = FLICManager.shared()?.buttons() ?? []
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
	
	func forgetAllButtons() {
		(FLICManager.shared()?.buttons() ?? [])
			.forEach { button in
				FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
					if let index = self.buttonsFound.firstIndex(where: { $0.identifier == uuid }) {
						self.buttonsFound.remove(at: index)
					}
				})
			}
	}
	
}

extension ButtonManager: FLICManagerDelegate {
	func managerDidRestoreState(_ manager: FLICManager) {
		print(#function)
		print(manager.state.description)
	}
	
	func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
		print(#function)
		print(state.description)
	}
}

extension ButtonManager: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(error?.localizedDescription ?? "nil error")
	}
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(error?.localizedDescription ?? "nil error")
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		print(nickname)
		print(button.identifier)
	}
	
	func button(_ button: FLICButton, didUpdateBatteryVoltage voltage: Float) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(queued)
		print(age)
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(queued)
		print(age)
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(error?.localizedDescription ?? "nil error")
	}
	
	func button(_ button: FLICButton, didReceiveButtonHold queued: Bool, age: Int) {
		print(#function)
		print(button.nickname ?? "no nick")
		print(button.identifier)
		print(queued)
		print(age)
	}
}

extension FLICManagerState {
	var description: String {
		switch self {
		case .poweredOff:
			return "Powered Off"
		case .poweredOn:
			return "Powered On"
		case .unsupported:
			return "Unsupported"
		case .resetting:
			return "Resetting"
		case .unauthorized:
			return "Unauthorized"
		default:
			return "Unknown"
		}
	}
}

extension FLICButton {
	var pongName: FlicName? {
		guard let nickname = nickname else { return nil }
		return FlicName(rawValue: nickname)
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
	
	var color: Color {
		switch self {
		case .connected:
			return .green
		case .disconnected:
			return .red
		default:
			return .white
		}
	}
}

enum FlicName: String, CaseIterable {
	case home = "Home"
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
