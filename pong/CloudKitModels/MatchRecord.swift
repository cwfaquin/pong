//
//  MatchRecord.swift
//  MatchRecord
//
//  Created by Charles Faquin on 9/15/21.
//

import Foundation
import CloudKit

class MatchRecord {
	private let id: CKRecord.ID
	
	let duration: Double
	let matchType: MatchType
	let matchMode: Int
	let guestPlayerRef: CKRecord.Reference?
	let homePlayerRef: CKRecord.Reference?
	var guestSetsRef: CKRecord.Reference?
	var homeSetsRef: CKRecord.Reference?

	
	init?(record: CKRecord) {
		id = record.recordID
		guard
			let duration = record["duration"] as? Double,
			let matchTypeInt = record["matchType"] as? Int,
			let matchType = MatchType(rawValue: matchTypeInt),
			let matchModeInt = record["matchMode"] as? Int
		else {
			return nil
		}
		self.duration = duration
		self.matchType = matchType
		self.matchMode = matchModeInt
		homePlayerRef = record["homePlayer"] as? CKRecord.Reference
		guestPlayerRef = record["guestPlayer"] as? CKRecord.Reference
		homeSetsRef = record["homeSets"] as? CKRecord.Reference
		guestSetsRef = record["guestSets"] as? CKRecord.Reference
	}
	
	static func fetchMatches(_ completion: @escaping (Result<[MatchRecord], Error>) -> Void) {
		let query = CKQuery(recordType: "Match",
												predicate: NSPredicate(value: true))
		let container = CKContainer.default()
		container.privateCloudDatabase.perform(query, inZoneWith: nil) { results, error in
			if let error = error {
				DispatchQueue.main.async {
					completion(.failure(error))
				}
				return
			}
				
			guard let results = results else {
				DispatchQueue.main.async {
					let error = NSError(
						domain: "com.cube.pong", code: -1,
						userInfo: [NSLocalizedDescriptionKey:
											 "Could not download matches"])
					completion(.failure(error))
				}
				return
			}
			
		}
	}
	
	static func fetchMatches(for players: [CKRecord.Reference], _ completion: @escaping ([MatchRecord]) -> Void) {
		let recordIDs = players.map { $0.recordID }
		let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
		operation.qualityOfService = .utility
	/*
		operation.fetchRecordsCompletionBlock = { records, error in
			let records = records?.values.map(MatchRecord.init) ?? []
			DispatchQueue.main.async {
				completion(records)
			}
		}*/
		
		//Model.currentModel.privateDB.add(operation)
	}
}

extension MatchRecord: Hashable {
	static func == (lhs: MatchRecord, rhs: MatchRecord) -> Bool {
		return lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
