//
//  Config.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import Foundation
import SwiftUI

struct Config {
	static let sclAppID: String = "cfe4b5bb-ba39-4e51-808a-f9dcaad86341"
	static let sclAppSecret: String = "bf6b88da-3c46-46be-bfdb-b3135819183a"
	
	static let height: CGFloat = UIScreen.main.bounds.height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
	static let width: CGFloat = UIScreen.main.bounds.width
}


