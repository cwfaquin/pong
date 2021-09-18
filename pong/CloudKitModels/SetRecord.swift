//
//  SetRecord.swift
//  SetRecord
//
//  Created by Charles Faquin on 9/17/21.
//

import Foundation
import CloudKit

final class SetRecord {
	
	let id: CKRecord.ID
	let homePlayerReference: CKRecord.Reference?
	let guestPlayerReference: CKRecord.Reference?
	let firstServe: TeamID
	let setType: GameType
	let homeGames: CKRecord.Reference?
	let guestGames: CKRecord.Reference?
	
	init(record: CKRecord) {
		id = record.recordID
		
	}
}
