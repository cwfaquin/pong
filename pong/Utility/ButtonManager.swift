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
	@Published var status1: String = ""
	@Published var status2: String = ""
	@Published var status3: String = ""
	
	var contract: ButtonContract?
	
	func configure(_ contract: ButtonContract) {
		self.contract = contract
		FLICManager.configure(with: self, buttonDelegate: self, background: false)
		updateButtons()
	}
	
	var allButtonsFound: Bool {
		(FLICManager.shared()?.buttons() ?? []).count == FlicName.allCases.count
	}
	
	func updateButtons() {
		buttonsFound = FLICManager.shared()?.buttons() ?? []
	}
	
	func numberFor(_ button: FLICButton) -> Int {
		(buttonsFound.firstIndex(of: button) ?? 0) + 1
	}

	func scanForButtons() {
		updateButtons()
		scanStatus = "Scanning"
		isScanning = true
		FLICManager.shared()?.scanForButtons(stateChangeHandler: { statusEvent in
			self.updateScanStatus(statusEvent)
		}, completion: { button, error in
			guard let button = button else {
				self.scanStatus = error?.localizedDescription ?? "Try scanning again"
				self.isScanning = false
				return
			}
			button.triggerMode = .clickAndDoubleClick
			self.updateButtons()
			self.scanStatus = ""
			self.isScanning = false
		})
	}
	
	func removeButton(_ button: FLICButton) {
		FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
			if let error = error {
				let name = "B\(self.numberFor(button))"
				let nickname = button.nickname ?? button.uuid
				self.updateStatus("Failed to forget button: \(name) - \(nickname) with error: \(error.localizedDescription).", for: button)
			}
			self.updateButtons()
		})
	}
	
	func forgetAllButtons() {
		FLICManager.shared()?.buttons().forEach { removeButton($0) }
	}
	
	func updateScanStatus(_ statusEvent: FLICButtonScannerStatusEvent) {
		switch statusEvent {
		case .discovered:
			scanStatus = "Flic button discovered"
		case .connected:
			scanStatus = "Flic button connected and is verifying."
		case .verified:
			scanStatus = "Flic button verified."
		case .verificationFailed:
			scanStatus = "Flic button verification failed."
		default:
			scanStatus = "Scanning"
		}
	}
}

extension ButtonManager: FLICManagerDelegate {
	func managerDidRestoreState(_ manager: FLICManager) {
		print(#function)
		updateScanStatus(manager.state)
	}
	
	func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
		print(#function)
		updateScanStatus(state)
	}
	
	func updateScanStatus(_ managerState: FLICManagerState) {
			switch managerState {
			case .poweredOn, .unknown:
				scanStatus = ""
			case .unsupported:
				scanStatus = "Device type unsupported"
			default:
				scanStatus = managerState.description
			}
	}
}

extension ButtonManager: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		updateStatus("Connected", for: button)
		updateButtons()
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		updateStatus("Ready", for: button)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		var text = "Disconnected"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		updateStatus(text, for: button)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		let errorText = "Button failed to connect. \(error?.localizedDescription ?? "")"
		updateStatus(errorText, for: button)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		let errorText = "Button unpaired. \(error?.localizedDescription ?? "")"
		updateStatus(errorText, for: button)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didUpdateBatteryVoltage voltage: Float) {
		print(#function)
		updateButtons()
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		updateStatus("Single-Click Received", for: button)
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		updateStatus("Double-Click Received", for: button)
	}
	
	func button(_ button: FLICButton, didReceiveButtonHold queued: Bool, age: Int) {
		print(#function)
		updateStatus("Hold Received", for: button)
	}
	
	func updateStatus(_ status: String?, for button: FLICButton) {
		guard let status = status else {
			updateButtons()
			return
		}
		switch numberFor(button) {
		case 1:
			status1 = status
		case 2:
			status2 = status
		case 3:
			status3 = status
		default:
			break
		}
	}
	
	func statusFor(_ button: FLICButton) -> String {
		switch numberFor(button) {
		case 1:
			return status1
		case 2:
			return status2
		case 3:
			return status3
		default:
			return "3 button max. Disconnect/forget one before adding another."
		}
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
	
	var imageName: String {
		switch self {
		case .home:
			return "house.circle"
		case .tableLeft:
			return "l.circle"
		case .tableRight:
			return "r.circle"
		}
	}
}
