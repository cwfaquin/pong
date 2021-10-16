//
//  PlayerSelectionVM.swift
//  PlayerSelectionVM
//
//  Created by Charles Faquin on 9/17/21.
//

import os.log
import Foundation
import CloudKit


final class PlayerSelectionVM: ObservableObject {
	
	enum State: Int {
		case loading
		case noResults
		case results
	}

	private let container = CKContainer(identifier: Config.containerIdentifier)
	private lazy var database = container.privateCloudDatabase
	
	@Published var state: PlayerSelectionVM.State = .loading
	@Published var players = [Player]()

	// MARK: - API
	
	func savePlayer(_ record: CKRecord, at index: Int?) {
		state = .loading
		database.save(record) { record, error in
			DispatchQueue.main.async {
				defer { self.state = self.players.isEmpty ? .noResults : .results }
				guard let record = record else {
				self.handleError(error, caller: #function)
				return
			}
			let player = Player(record: record)
			if let index = index {
				self.players[index] = player
			}
			}
		}
	}
	
	func fetchPlayers() {
		state = .loading
		let query = CKQuery(recordType: Player.recordType, predicate: NSPredicate(value: true))
		database.perform(query, inZoneWith: nil) { records, error in
			DispatchQueue.main.async {
				defer { self.state = self.players.isEmpty ? .noResults : .results }
				guard let records = records else {
					self.handleError(error, caller: #function)
					return
				}
				self.players = records.map(Player.init)
			}
		}
	}
	
	func deletePlayers(at offsets: IndexSet) {
		let playersToDelete = offsets.compactMap { players[$0] }
		players.remove(atOffsets: offsets)
		playersToDelete.forEach {
			deletePlayer($0)
		}
	}
	
	func deletePlayer(_ player: Player) {
		if let index = players.firstIndex(of: player) {
			players.remove(at: index)
		}
		state = .loading
		database.delete(withRecordID: player.recordId) { recordId, error in
			DispatchQueue.main.async {
				self.state = self.players.isEmpty ? .noResults : .results
				guard error == nil else {
				self.handleError(error, caller: #function)
				return
			}
			}
		}
	}
	
	
	func handleError(_ error: Error?, caller: String) {
		print("error function: \(caller)")
		let errorPrint = error?.localizedDescription ?? "Unknown Error"
		print(errorPrint)
	}
	
	private func reportError(_ error: Error) {
			guard let ckerror = error as? CKError else {
					os_log("Not a CKError: \(error.localizedDescription)")
					return
			}

			switch ckerror.code {
			case .partialFailure:
					// Iterate through error(s) in partial failure and report each one.
					let dict = ckerror.userInfo[CKPartialErrorsByItemIDKey] as? [NSObject: CKError]
					if let errorDictionary = dict {
							for (_, error) in errorDictionary {
									reportError(error)
							}
					}

			// This switch could explicitly handle as many specific errors as needed, for example:
			case .unknownItem:
					os_log("CKError: Record not found.")

			case .notAuthenticated:
					os_log("CKError: An iCloud account must be signed in on device or Simulator to write to a PrivateDB.")

			case .permissionFailure:
					os_log("CKError: An iCloud account permission failure occured.")

			case .networkUnavailable:
					os_log("CKError: The network is unavailable.")

			default:
					os_log("CKError: \(error.localizedDescription)")
			}
	}
}

