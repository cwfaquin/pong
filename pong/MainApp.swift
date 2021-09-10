//
//  pongApp.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI
import flic2lib
import UserNotifications

@main
struct MainApp: App {
	
	@StateObject var viewModel = MainAppVM()
	@StateObject var match = Match()

	var body: some Scene {
		WindowGroup {
			ScoreboardView()
				.environmentObject(match)
				.onAppear {
					viewModel.requestNotificationAuthorization()
				}
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
