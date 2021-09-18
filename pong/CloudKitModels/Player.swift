//
//  Player.swift
//  Player
//
//  Created by Charles Faquin on 9/15/21.
//

import SwiftUI
import CloudKit


enum PlayerKeys: String, CaseIterable {
	case username
	case avatar
	case firstName
	case lastName
	case pinRequired
	case pin
}

struct Player: Identifiable, Hashable {
	static let recordType = "Player"

	var id: CKRecord.ID
	var username: String?
	var firstName: String?
	var lastName: String?
	var pinRequired: Bool = false
	var pin: Int?
	var avatar: CKAsset?
	var avatarUrl: URL?
	
	init(record: CKRecord) {
		id = record.recordID
		updateFrom(record)
	}
	
	mutating func updateFrom(_ record: CKRecord) {
		id = record.recordID
		username = record[PlayerKeys.username.rawValue] as? String
		firstName = record[PlayerKeys.firstName.rawValue] as? String
		lastName = record[PlayerKeys.lastName.rawValue] as? String
		pin = record[PlayerKeys.pin.rawValue] as? Int
		pinRequired = record[PlayerKeys.pinRequired.rawValue] as? Bool ?? false
		avatar = record[PlayerKeys.avatar.rawValue] as? CKAsset

		/*if let matchRecords = record["matches"] as? [CKRecord.Reference] {
			MatchRecord.fetchMatches(for: matchRecords) { matches in
				self.matches = matches
			}
		}*/
	}
	
	
	func makePlayerRecord() -> CKRecord {
		let record = CKRecord(recordType: Self.recordType, recordID: id)
		var value: CKRecordValue?
		PlayerKeys.allCases.forEach {
			switch $0 {
			case .firstName:
				value = firstName as CKRecordValue?
			case .lastName:
				value = lastName as CKRecordValue?
			case .username:
				value = username as CKRecordValue?
			case .pinRequired:
				value = pinRequired as CKRecordValue?
			case .pin:
				value = pin as CKRecordValue?
			case .avatar:
				if let url = avatarUrl {
					value = CKAsset(fileURL: url)
				} else {
					value = nil
				}
			}
			record.setObject(value, forKey: $0.rawValue)
		}
	}
	
	func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
					
					let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
					let fileURL = documentsUrl.appendingPathComponent(fileName)
					do {
							let imageData = try Data(contentsOf: fileURL)
							return UIImage(data: imageData)
					} catch {}
					return nil
			}
	
	
	mutating func saveImageInDocumentDirectory(image: UIImage?, fileName: String) {
			guard
				let image = image,
				let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		else {
			avatarUrl = nil
			return
		}
		let fileURL = documentsUrl.appendingPathComponent(fileName)
		if let imageData = image.pngData() {
			try? imageData.write(to: fileURL, options: .atomic)
			avatarUrl = fileURL
		} else {
			avatarUrl = nil
		}
	}
	
	func loadAvatar(completion: @escaping (_ photo: Image?) -> ()) {
		DispatchQueue.global(qos: .utility).async {
			var image: Image?
			defer {
				DispatchQueue.main.async {
					completion(image)
				}
			}
			guard let fileURL = self.avatar?.fileURL else { return }
			do {
				let imageData = try Data(contentsOf: fileURL)
				if let uiImage = UIImage(data: imageData) {
					image = Image(uiImage: uiImage)
				}
			} catch {
				return
			}
		}
	}
}







class _Player {
	
	let record: CKRecord
	let username: String
	let avatar: CKAsset?
	let firstName: String
	let lastName: String
	let pinRequired: Bool
	let pin: Int
	
	private(set) var matches = [MatchRecord]()
	

	
	
	init?(record: CKRecord, database: CKDatabase) {
		guard
			let username = record["username"] as? String,
			let firstName = record["firstName"] as? String,
			let lastName = record["lastName"] as? String,
			let pin = record["pin"] as? Int
			else
		{ return nil }
		id = record.recordID
		self.username = username
		self.firstName = firstName
		self.lastName = lastName
		self.pin = pin
		pinRequired = record["pinRequired"] as? Bool ?? false
		avatar = record["avatar"] as? CKAsset

		if let matchRecords = record["matches"] as? [CKRecord.Reference] {
			MatchRecord.fetchMatches(for: matchRecords) { matches in
				self.matches = matches
			}
		}
	}
	
	func loadAvatar(completion: @escaping (_ photo: Image?) -> ()) {
		DispatchQueue.global(qos: .utility).async {
			var image: Image?
			defer {
				DispatchQueue.main.async {
					completion(image)
				}
			}
			guard let fileURL = self.avatar?.fileURL else { return }
			do {
				let imageData = try Data(contentsOf: fileURL)
				if let uiImage = UIImage(data: imageData) {
					image = Image(uiImage: uiImage)
				}
			} catch {
				return
			}
		}
	}
}

