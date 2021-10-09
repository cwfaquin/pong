//
//  ButtonManager.swift
//  pong
//
//  Created by Charles Faquin on 9/30/21.
//

import Foundation
import flic2lib
import SwiftUI

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
			return "Table Left (Facing Scoreboard)"
		case .tableRight:
			return "Table Right (Facing Scoreboard)"
		case .unassigned:
			return "Unassigned Button"
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
