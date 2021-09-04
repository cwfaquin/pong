//
//  Font+Size.swift
//  Font+Size
//
//  Created by Charles Faquin on 9/3/21.
//

import SwiftUI

extension Text {
	var teamFont: some View {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return self.font(.headline)
		case .pad:
			return self.font(.largeTitle)
		default:
			return self.font(.system(size: 55, weight: .medium, design: .rounded))
		}
	}
	
	var seriesFont: some View {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return self.font(.title3)
		case .pad:
			return self.font(.largeTitle)
		default:
			return self.font(.system(size: 50, weight: .medium, design: .rounded))
		}
	}
	
	var serviceFont: some View {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return self.font(.title2)
		case .pad:
			return self.font(.largeTitle)
		default:
			return self.font(.system(size: 55, weight: .medium, design: .rounded))
		}
	}
}
