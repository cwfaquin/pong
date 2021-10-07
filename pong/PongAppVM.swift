//
//  MainAppVM.swift
//  MainAppVM
//
//  Created by Charles Faquin on 8/21/21.
//

import Combine
import flic2lib
import AudioToolbox

final class PongAppVM: NSObject, ObservableObject {
	
	@Published var flicAction: FlicAction?
	@Published var managerState: FLICManagerState = .poweredOff
//	@Published var leftButton: FLICButton?
//	@Published var rightButton: FLICButton?
//	@Published var homeButton: FLICButton?
	@Published var buttonDict = [UUID: String]()
	@Published var managerReady = false
	@Published var isScanning = false
	@Published var message = ""
	@Published var scanViewVisible = false
	@Published var pairedButtons = [FLICButton]()
	private var pairedSet = Set<FLICButton>() {
		didSet {
			pairedButtons = Array(pairedSet)
				.sorted { $0.uuid < $1.uuid }
		}
	}
	
	override init() {
		super.init()
			FLICManager.configure(with: self, buttonDelegate: self, background: true)
	}
	
	func handleURL(_ url: URL) {
		guard
			let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
			components.scheme == "pong",
			let host = components.host
		else {
			return
		}
		flicAction = FlicAction(rawValue: host)
	}
	
	func scanForButtons() {
		guard managerReady else {
			message = managerState.description
			return
		}
		isScanning = true
		message = "Press and hold button for 6 seconds to pair."
		FLICManager.shared()?.scanForButtons(stateChangeHandler: { statusEvent in
			DispatchQueue.main.async {
				switch statusEvent {
				case .discovered:
					self.message = "Flic button discovered"
				case .connected:
					self.message = "Flic button connected and is verifying."
				case .verified:
					self.message = "Flic button verified."
				case .verificationFailed:
					self.message = "Flic button verification failed."
				default:
					self.message = "Scanning for Flic Buttons..."
				}
			}
		}, completion: { button, error in
			self.isScanning = false
			guard let button = button else {
				self.message = error?.localizedDescription ?? ""
				return
			}
			self.updatePaired(button)
			self.message = "Buttons Found: \(self.pairedButtons.count)"
		/*	switch button.pongName {
			case .tableLeft:
				self.leftButton = button
			case .tableRight:
				self.rightButton = button
			case .home:
				self.homeButton = button
			default:
				print("Unassigned Button")
			}*/
			button.triggerMode = .clickAndDoubleClick
			button.connect()
		})
	}
}

extension PongAppVM: FLICManagerDelegate {
	func managerDidRestoreState(_ manager: FLICManager) {
		print(#function)
		managerReady = true
		let buttons = FLICManager.shared()?.buttons() ?? []
		if buttons.isEmpty {
			message = "While Scanning, hold Flic Button for 6 seconds to enter pairing mode."
		}
		buttons.forEach {
			updatePaired($0)
			$0.delegate = self 
			$0.connect()
		}
	}
	
	func manager(_ manager: FLICManager, didUpdate state: FLICManagerState) {
		print(#function)
		print(state.description)
		managerState = state
	}
	
	/*func update(_ button: FLICButton) {
		switch button.pongName {
		case .tableLeft:
			leftButton = button
		case .tableRight:
			rightButton = button
		case .home:
			homeButton = button
		default:
			print("Unassigned Button nickname: \(button.nickname ?? "")")
		}
	}*/
	
	func updatePaired(_ button: FLICButton) {
		pairedSet.update(with: button)
	}
}

extension PongAppVM: FLICButtonDelegate {
	func buttonDidConnect(_ button: FLICButton) {
		print(#function)
		//update(button)
		updatePaired(button)
	}
	
	func buttonIsReady(_ button: FLICButton) {
		print(#function)
		//update(button)
		updatePaired(button)
		button.delegate = self
	}
	
	func button(_ button: FLICButton, didUpdateNickname nickname: String) {
		print(#function)
		//update(button)
		updatePaired(button)
	}
	
	func button(_ button: FLICButton, didReceiveButtonClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		guard !scanViewVisible else {
			buttonDict[button.identifier] = "Single Click Received"
			return
		}
		switch button.pongName {
		case .tableLeft:
			flicAction = .singleTapLeft
			playSound(.singleTapSide)
		case .tableRight:
			flicAction = .singleTapRight
			playSound(.singleTapSide)
		case .home:
			flicAction = .singleTapHome
			playSound(.singleTapMiddle)
		default:
			playSound(.button1)
			flicAction = nil
		}
	}
		/*switch button {
		case leftButton where button.pongName == .tableLeft:
			flicAction = .singleTapLeft
			playSound(.singleTapSide)
		case rightButton where button.pongName == .tableRight:
			flicAction = .singleTapRight
			playSound(.singleTapSide)
		case homeButton where button.pongName == .home:
			flicAction = .singleTapHome
			playSound(.singleTapMiddle)
		default:
			playSound(.button1)
			flicAction = nil
			assertionFailure("Unnamed Button clicked")
			return
		}*/
	
	
	func button(_ button: FLICButton, didReceiveButtonDoubleClick queued: Bool, age: Int) {
		print(#function)
		print("queued = \(queued), age = \(age)")
		guard !scanViewVisible else {
			buttonDict[button.identifier] = "Double Click Received"
			return
		}
		switch button.pongName {
		case .tableLeft:
			flicAction = .doubleTapLeft
		case .tableRight:
			flicAction = .doubleTapRight
		case .home:
			flicAction = .doubleTapHome
		default:
			playSound(.button1)
			return
		}
		playSound(.doubleTap)
	}
	
	func button(_ button: FLICButton, didUnpairWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		//update(button)
		var text = "Unpaired"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		buttonDict[button.identifier] = text
		if let index = pairedButtons.firstIndex(of: button) {
			pairedButtons.remove(at: index)
		}
	}
	
	func button(_ button: FLICButton, didDisconnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		//update(button)
		var text = "Disconnected"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		buttonDict[button.identifier] = text
		updatePaired(button)
	}
	
	
	func button(_ button: FLICButton, didFailToConnectWithError error: Error?) {
		print(#function)
		print(String(describing: error))
		//update(button)
		var text = "Connection Failure"
		if let error = error {
			text += ". \(error.localizedDescription)"
		}
		buttonDict[button.identifier] = text
		updatePaired(button)
	}
}

extension PongAppVM {
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

extension FLICButton: Identifiable {
	public var id: String {
		uuid
	}
}

