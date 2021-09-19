//
//  GameRecord.swift
//  GameRecord
//
//  Created by Charles Faquin on 9/17/21.
//

import Foundation
import CloudKit

final class GameRecord {
	
	var id: CKRecord.ID
	private(set) var noteLabel: String?
	var homePlayerReference: CKRecord.Reference?
	var guestPlayerReference: CKRecord.Reference?
	var deuce: Bool = false
	var duration: Double = 0
	var firstService: TeamID?
	var gameType: GameType?
	var homeScore: Int?
	var guestScore: Int?
	var homeSide: TableSide?

	
	init(record: CKRecord) {
		id = record.recordID
		
	}
}
