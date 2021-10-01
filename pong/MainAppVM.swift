//
//  MainAppVM.swift
//  MainAppVM
//
//  Created by Charles Faquin on 8/21/21.
//

import Combine
import UserNotifications

final class MainAppVM: NSObject, ObservableObject {
	
	@Published var flicAction: FlicAction?
	
	func requestNotificationAuthorization() {
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [], completionHandler: { granted, error in
			print("Permission = \(granted)")
			guard let error = error else { return }
			print(error.localizedDescription)
		})
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
}

extension MainAppVM: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		print(notification.request.content.userInfo)
		completionHandler([.sound])
	}
	
	
}
