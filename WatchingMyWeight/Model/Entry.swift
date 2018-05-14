//
//  Entry.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation

enum Units: String, Codable {
	case kg = "kg"
	case lbs = "lbs"
}

class Entry : Codable {

	var weight: Double
	var units: Units
	var date: Date

	init(weight: Double, units: Units, date: Date) {
		self.weight = weight
		self.units = units
		self.date = date
	}

}

var entries = [Entry]()

func readEntries() {
	let defaults = UserDefaults.standard

	if let savedData = defaults.object(forKey: "entries") as? Data {
		let jsonDecoder = JSONDecoder()

		do {
			entries = try jsonDecoder.decode([Entry].self, from: savedData)
		}
		catch {
			print("Failed to load entries!")
		}
	}
}

func writeEntries() {
	let jsonEncoder = JSONEncoder()
	if let savedData = try? jsonEncoder.encode(entries) {
		let defaults = UserDefaults.standard
		defaults.set(savedData, forKey: "entries")
	}
	else {
		print("Failed to save entries!")
	}
}
