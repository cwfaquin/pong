//
//  WindowSize.swift
//  WindowSize
//
//  Created by Charles Faquin on 8/31/21.
//

import Foundation

final class WindowSize: ObservableObject {
	
	@Published var width: CGFloat
	@Published var height: CGFloat
	
	init(_ size: CGSize) {
		self.width = size.width
		self.height = size.height
	}
	
	var midLabelWidth: CGFloat {
		width/5
	}
	
	var scoreHeight: CGFloat {
		height/2
	}
	
	var seriesHeight: CGFloat {
		height/8
	}
	
	var teamHeight: CGFloat {
		height/4
	}
}
