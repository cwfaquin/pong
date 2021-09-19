//
//  SetRecord.swift
//  SetRecord
//
//  Created by Charles Faquin on 9/17/21.
//

import Foundation
import CloudKit

final class SetRecord {
	
	var id: CKRecord.ID
	var homePlayerReference: CKRecord.Reference?
	var guestPlayerReference: CKRecord.Reference?
	var firstServe: TeamID?
	var setType: GameType?
	var homeGames: CKRecord.Reference?
	var guestGames: CKRecord.Reference?
	
	init(record: CKRecord) {
		id = record.recordID
		
	}
}
