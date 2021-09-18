//
//  GameRecord.swift
//  GameRecord
//
//  Created by Charles Faquin on 9/17/21.
//

import Foundation
import CloudKit

final class GameRecord {
	
	let id: CKRecord.ID
	private(set) var noteLabel: String?
	let homePlayerReference: CKRecord.Reference?
	let guestPlayerReference: CKRecord.Reference?
	let deuce: Bool
	let duration: Double
	let firstService: TeamID
	let gameType: GameType
	let homeScore: Int
	let guestScore: Int
	let homeSide: TableSide

	
	init(record: CKRecord) {
		id = record.recordID
		
	}
}
