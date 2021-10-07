//
//  PongApp.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI
import flic2lib
import UserNotifications

@main
struct PongApp: App {
	
	@StateObject var viewModel = PongAppVM()
	@StateObject var match = Match()
	
	#if targetEnvironment(macCatalyst)
		let isMacApp: Bool = true
	#else
		let isMacApp: Bool = false
	#endif
	
	init() {
		Storage.isMacApp = isMacApp
	}
	
	var body: some Scene {
		WindowGroup {
			ScoreboardView()
				.environmentObject(match)
				.environmentObject(viewModel)
				.onReceive(viewModel.$flicAction) { action in
					switch action {
					case .singleTapHome:
						match.singleTapMiddle()
					case .doubleTapHome:
						match.singleTapMiddle()
					case .singleTapLeft:
						match.singleTap(.left)
					case .doubleTapLeft:
						match.doubleTap(.left)
					case .singleTapRight:
						match.singleTap(.right)
					case .doubleTapRight:
						match.doubleTap(.right)
					default:
						break
					}
				}
				.onOpenURL { url in
						viewModel.handleURL(url)
				}
		}
		
	}
}

struct Storage {
	static var isMacApp: Bool {
		get {
			UserDefaults.standard.bool(forKey: #function)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: #function)
		}
	}
}
