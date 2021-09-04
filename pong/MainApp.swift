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
	
	@ObservedObject var viewModel = MainAppVM()
	@State var settings = MatchSettings()
	@State var match = Match()
	
	var body: some Scene {
		WindowGroup {
			ScoreboardView(viewModel: ScoreboardVM())
				.environmentObject(settings)
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

class SGConvenience{
		#if os(watchOS)
		static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
		#elseif os(iOS)
		static var deviceWidth:CGFloat = UIScreen.main.bounds.size.width
		#elseif os(macOS)
		static var deviceWidth:CGFloat? = NSScreen.main?.visibleFrame.size.width // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
		#endif
}
