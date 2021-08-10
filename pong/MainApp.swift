//
//  pongApp.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI
import flic2lib

@main
struct MainApp: App {
	
	@State var settings = MatchSettings()
	@State var match = Match()
	
    var body: some Scene {
        WindowGroup {
            ScoreboardView(viewModel: ScoreboardVM())
							.environmentObject(settings)
							.environmentObject(match)
							.background(Color.black.ignoresSafeArea())
				}
		}

							/*.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
								SCLFlicManager.configure(with: self, defaultButtonDelegate: self, appID: SCL_APP_ID, appSecret: SCL_APP_SECRET, backgroundExecution: false)

							}*/
					
}

