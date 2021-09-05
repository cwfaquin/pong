//
//  AnyTransition+View.swift
//  AnyTransition+View
//
//  Created by Charles Faquin on 9/5/21.
//

import Foundation
import SwiftUI

extension AnyTransition {
		static var bottomToTop: AnyTransition {
				let insertion = AnyTransition.move(edge: .bottom)
				.combined(with: .scale)
			let removal = AnyTransition.move(edge: .top)
				.combined(with: .scale)
				return .asymmetric(insertion: insertion, removal: removal)
		}
}
