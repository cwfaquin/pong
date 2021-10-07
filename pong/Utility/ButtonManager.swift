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
	@Published var scanStatus: String = ""
	@Published var statusDict = [UUID: String]()
	@Published var connected = Set<FLICButton>()
	@Published var paired = [FLICButton]()
	
	var contract: ButtonContract?
	
	
	func configure() {
		FLICManager.configure(with: self, buttonDelegate: self, background: true)
		paired = FLICManager.shared()?.buttons() ?? []
		if paired.isEmpty {
			scanForButtons()
		}
	}
	
	func removeButton(_ button: FLICButton) {
		FLICManager.shared()?.forgetButton(button, completion: { uuid, error in
			if let error = error {
				self.statusDict[uuid] = "Failed to forget button with error: \(error.localizedDescription)."
			} else {
				self.statusDict.removeValue(forKey: uuid)
			}
		})
	}
	
	func forgetAllButtons() {
		FLICManager.shared()?.buttons().forEach { removeButton($0) }
	}
	
	func scanForButtons() {
		isScanning = true
		scanStatus = "Scanning"
		FLICManager.shared()?.scanForButtons(stateChangeHandler: { statusEvent in
			self.updateScanStatus(statusEvent)
		}, completion: { button, error in
			self.isScanning = false
			guard let button = button else {
				self.scanStatus = error?.localizedDescription ?? "Try scanning again"
				return
			}
			button.triggerMode = .clickAndDoubleClick
			button.connect()
			if !self.paired.contains(button) {
				self.paired.append(button)
			}
			self.scanStatus = ""
		})
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
	
	func removeFromConnected(_ button: FLICButton) {
		if let index = connected.firstIndex(of: button) {
			connected.remove(at: index)
		}
	}
}

extension ButtonManager: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		statusDict[button.identifier] = "Connected"
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		connected.update(with: button)
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		var text = "Disconnected"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		statusDict[button.identifier] = text
		removeFromConnected(button)
	}
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		var text = "Connection Failure"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		statusDict[button.identifier] = text
		removeFromConnected(button)
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		var text = "Unpaired"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		statusDict[button.identifier] = text
		removeFromConnected(button)
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		statusDict[button.identifier] = "\(nickname)"
		if let pongName = FlicName(rawValue: nickname), let index = paired.firstIndex(where: { $0.pongName == pongName && $0.identifier != button.identifier}) {
			paired[index].nickname = ""
		}
		paired.first(where: {$0.identifier == button.identifier})?.nickname = nickname
	}

	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		statusDict[button.identifier] = "Single-Click Received"
		contract?.singleClick(button.pongName.tableSide)
		
	}
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		statusDict[button.identifier] = "Double-Click Received"
			contract?.doubleClick(button.pongName.tableSide)
		
	}
	
	func button(_ button: FLICButton, didReceiveButtonHold queued: Bool, age: Int) {
		print(#function)
		statusDict[button.identifier] = "Hold Received"
		contract?.longPress(button.pongName.tableSide)
		
	}
}

extension FLICManagerState {
	var description: String {
		switch self {
		case .poweredOff:
			return "Bluetooth is turned off"
		case .poweredOn:
			return "Bluetooth is turned on"
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
	var pongName: FlicName {
		guard let nickname = nickname else { return .unassigned }
		return FlicName(rawValue: nickname) ?? .unassigned
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

enum FlicName: String, CaseIterable, Identifiable {
	case tableLeft
	case home
	case tableRight
	case unassigned
	
	var singleSound: ScoreboardVM.SoundType {
		switch self {
		case .home:
			return .singleTapMiddle
		case .unassigned:
			return .button1
		default:
			return .singleTapSide
		}
	}
	
	var tableSide: TableSide? {
		switch self {
		case .home:
			return nil
		case .tableLeft:
			return .left
		case .tableRight:
			return .right
		case .unassigned:
			return nil
		}
	}
	
	var doubleSound: ScoreboardVM.SoundType {
		switch self {
		case .unassigned:
			return .button1
		default:
			return .doubleTap
		}
	}
	
	var description: String {
		switch self {
		case .home:
			return "Home Button"
		case .tableLeft:
			return "Left Table (facing scoreboard)"
		case .tableRight:
			return "Right Table (facing scoreboard)"
		case .unassigned:
			return "⚠️ Unassigned Button ⚠️"
		}
	}
	
	var imageName: String {
		switch self {
		case .home:
			return "house"
		case .tableLeft:
			return "lt.rectangle.roundedtop"
		case .tableRight:
			return "rt.rectangle.roundedtop"
		case .unassigned:
			return "minus"
		}
	}
	
	var id: String {
		rawValue
	}
}
