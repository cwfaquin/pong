//
//  User.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI

struct User {
	let id: UUID
	let teamId: TeamID
	var teamName: String
	var username: String
	let firstName: String?
	let lastName: String?
	var avatarUrl: String?
	var avatarName: String?
}


