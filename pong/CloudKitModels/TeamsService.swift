//
//  TeamsService.swift
//  TeamsService
//
//  Created by Charles Faquin on 9/16/21.
//
/*
import Foundation
import CloudKit

enum RecordType {
	case match = "Match"
	case player = "Player"
	case game = "Game"
	case set = "Set"
}

struct TeamsService {
	
	static func fetchPlayers(completion: @escaping Result<[Player, Error]>) {
		let publicDatabase = CKContainer(identifier:"").publicCloudDatabase
		
		let query = CKQuery(recordType: RecordType, predicate: NSPredicate(value: true))
		query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
		
		publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID, completionHandler: { (records, error) -> Void in
			self.processQueryResponseWith(records: records, error: error as NSError?, completion: { fetchedRecords, fetchError in
				completion(fetchedRecords, fetchError)
			})
		})
	}
	
	
	static func deleteRecord(record: CKRecord) {
		let publicDatabase = CKContainer(identifier: "{YOUR_CONTAINER_IDENTIFIER}").publicCloudDatabase
		
		publicDatabase.delete(withRecordID: record.recordID) { (recordID, error) -> Void in
			guard let _ = error else {
				completionHandler(.none)
				return
			}
			
			completionHandler(.deletingError)
		}
	}
	
	static func addTask() {
		let publicDatabase = CKContainer(identifier: "{YOUR_CONTAINER_IDENTIFIER}").publicCloudDatabase
		let record = CKRecord(recordType: RecordType)
		
		record.setObject(task as __CKRecordObjCValue, forKey: "title")
		record.setObject(Date() as __CKRecordObjCValue, forKey: "createdAt")
		record.setObject(0 as __CKRecordObjCValue, forKey: "checked")
		
		publicDatabase.save(record, completionHandler: { (record, error) in
			guard let _ = error else {
				completionHandler(record, .none)
				return
			}
			
			completionHandler(nil, .addingError)
		})
	}
}
*/
