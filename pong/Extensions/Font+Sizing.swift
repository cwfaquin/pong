//
//  Font+Size.swift
//  Font+Size
//
//  Created by Charles Faquin on 9/3/21.
//

import SwiftUI

extension Font {
	static var teamFont: Font {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return .headline
		default:
			return .system(size: 100, weight: .bold, design: .monospaced)
		}
	}
	
	static var seriesFont: Font {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return .title3
		default:
			return .system(size: 55, weight: .ultraLight, design: .rounded)
		}
	}
	
	static var serviceFont: Font {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return .title2
		default:
			return .system(size: 70, weight: .regular, design: .default)
		}
	}
}
