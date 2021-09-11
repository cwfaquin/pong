//
//  CGFloat+Sizing.swift
//  CGFloat+Sizing
//
//  Created by Charles Faquin on 9/4/21.
//

import SwiftUI

extension CGFloat {
	static func panelWidth(_ screenWidth: CGFloat) -> CGFloat {
		Swift.min(Swift.max(150, screenWidth/4.5), 350)
	}
}
