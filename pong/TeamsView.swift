//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@EnvironmentObject var match: Match
	@Binding var showSettings: Bool
	
	var body: some View {
		HStack {
			TeamView(tableSide: .left)
			VStack {
				Button(action: { match.singleTapMiddle() }) {
					ButtonImage(systemName: "house")
				}
				Button(action: { showSettings = !showSettings }) {
					ButtonImage(systemName: "gear")
				}
			}
			TeamView(tableSide: .right)
		}
	}
	
	
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(showSettings: .constant(false))
	}
}
