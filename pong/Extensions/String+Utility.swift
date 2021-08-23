//
//  String+Utility.swift
//  String+Utility
//
//  Created by Charles Faquin on 8/23/21.
//

import Foundation

extension String {
	var spaced: String {
		var text = " "
		forEach {
			text.append(contentsOf: "\($0) ")
		}
		return text
	}
}
