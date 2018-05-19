//
//  Weight.swift
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

class Weight : Codable {

	var weight: Double
	var units: Units
	var date: Date

	init(weight: Double, units: Units, date: Date) {
		self.weight = weight
		self.units = units
		self.date = date
	}

}

var weights = [Weight]()

func sortWeights() {
	weights.sort {
		if $0.date > $1.date {
			return true
		}
		return false
	}
}

func readWeights() {
//	let defaults = UserDefaults.standard
	let defaults = NSUbiquitousKeyValueStore.default
	defaults.synchronize()

	if let savedData = defaults.object(forKey: "weights") as? Data {
		let jsonDecoder = JSONDecoder()

		do {
			weights = try jsonDecoder.decode([Weight].self, from: savedData)
		}
		catch {
			print("Failed to load weights!")
		}
	}
}

func writeWeights() {
	let jsonEncoder = JSONEncoder()
	if let savedData = try? jsonEncoder.encode(weights) {
//		let defaults = UserDefaults.standard
		let defaults = NSUbiquitousKeyValueStore.default
		defaults.set(savedData, forKey: "weights")
		defaults.synchronize()
	}
	else {
		print("Failed to save weights!")
	}
}
