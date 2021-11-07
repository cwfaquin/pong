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

struct Player {

	
	static let recordType = "Player"
	static let newPlayer = Player(record: CKRecord(recordType: Player.recordType))


	var id: String {
		recordId.recordName
	}
	var recordId: CKRecord.ID
	var username = ""
	var firstName = ""
	var lastName = ""
	var pinRequired = false
	var pin = ""
	var avatar: CKAsset?
	var avatarUrl: URL?
	var avatarImage: UIImage?
	

	init(record: CKRecord) {
		recordId = record.recordID
		updateFrom(record)

	}
	
	mutating func updateFrom(_ record: CKRecord) {
		recordId = record.recordID
		username = record[PlayerKeys.username.rawValue] as? String ?? username
		firstName = record[PlayerKeys.firstName.rawValue] as? String ?? firstName
		lastName = record[PlayerKeys.lastName.rawValue] as? String ?? lastName
		pin = record[PlayerKeys.pin.rawValue] as? String ?? pin
		pinRequired = record[PlayerKeys.pinRequired.rawValue] as? Bool ?? false
		avatar = record[PlayerKeys.avatar.rawValue] as? CKAsset
		guard
			let fileURL = avatar?.fileURL,
			let imageData = try? Data(contentsOf: fileURL),
			let image = UIImage(data: imageData)
		else {
			avatarImage = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
			return
		}
		avatarImage = image

		/*if let matchRecords = record["matches"] as? [CKRecord.Reference] {
			MatchRecord.fetchMatches(for: matchRecords) { matches in
				self.matches = matches
			}
		}*/
	}
	
	
	func makePlayerRecord() -> CKRecord {
		let record = CKRecord(recordType: Self.recordType, recordID: recordId)
		var value: CKRecordValue?
		PlayerKeys.allCases.forEach {
			switch $0 {
			case .firstName:
				value = firstName as CKRecordValue
			case .lastName:
				value = lastName as CKRecordValue
			case .username:
				value = username as CKRecordValue
			case .pinRequired:
				value = pinRequired as CKRecordValue
			case .pin:
				value = pin as CKRecordValue
			case .avatar:
				if let url = avatarUrl {
					value = CKAsset(fileURL: url)
				} else {
					value = nil
				}
			}
			record.setObject(value, forKey: $0.rawValue)
		}
		return record
	}
	/*
	func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
					
					let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
					let fileURL = documentsUrl.appendingPathComponent(fileName)
					do {
							let imageData = try Data(contentsOf: fileURL)
							avatarImage = UIImage(data: imageData)
					} catch {
						avatarImage = UIImage(systemName: "person.circle")
					}
					return nil
			}
	
	
	func saveImageInDocumentDirectory(image: UIImage?, fileName: String) {
		
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
	}*/
	
	func loadAvatar(completion: @escaping (_ photo: UIImage?) -> ()) {
		DispatchQueue.global(qos: .utility).async {
			var image: UIImage?
			defer {
				DispatchQueue.main.async {
					completion(image)
				}
			}
			guard let fileURL = self.avatar?.fileURL else { return }
			do {
				let imageData = try Data(contentsOf: fileURL)
				image = UIImage(data: imageData)
			} catch {
				return
			}
		}
	}
}

extension Player: Identifiable, Hashable, Equatable {
	static func == (lhs: Player, rhs: Player) -> Bool {
		lhs.id == rhs.id
	}
}

extension String {
	var isValidPIN: Bool {
		guard trimmingCharacters(in: .whitespacesAndNewlines).count == 4 else { return false }
		return rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
	}
}
