//
//  SizePreferencKey.swift
//  SizePreferencKey
//
//  Created by Charles Faquin on 8/22/21.
//

import Foundation
import SwiftUI

struct PreferenceKeySize: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
