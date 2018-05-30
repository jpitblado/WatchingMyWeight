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

struct Weight : Codable {

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
	switch settings.dataStorage {
	case .Local:
		localReadWeights()
	case .iCloud:
		iCloudReadWeights()
	case .HealthApp:
		break
	}
}

func localReadWeights() {
	let defaults = UserDefaults.standard

	if let savedData = defaults.object(forKey: "weights") as? Data {
		let jsonDecoder = JSONDecoder()

		do {
			weights = try jsonDecoder.decode([Weight].self, from: savedData)
		}
		catch {
			NSLog("Failed to read weights from device!")
		}
	}
	else {
		NSLog("No weights stored on device. Using empty array.")
		weights = [Weight]()
	}
}

func iCloudReadWeights() {
	let defaults = NSUbiquitousKeyValueStore.default
	defaults.synchronize()

	if let savedData = defaults.object(forKey: "weights") as? Data {
		let jsonDecoder = JSONDecoder()

		do {
			weights = try jsonDecoder.decode([Weight].self, from: savedData)
		}
		catch {
			NSLog("Failed to read weights from iCloud!")
		}
	}
	else {
		NSLog("No weights stored in iCloud. Using empty array.")
		weights = [Weight]()
	}
}

func writeWeights() {
	switch settings.dataStorage {
	case .Local:
		localWriteWeights()
	case .iCloud:
		iCloudWriteWeights()
	case .HealthApp:
		break
	}
}

func localWriteWeights() {
	let jsonEncoder = JSONEncoder()
	if let savedData = try? jsonEncoder.encode(weights) {
		let defaults = UserDefaults.standard
		defaults.set(savedData, forKey: "weights")
		defaults.synchronize()
	}
	else {
		NSLog("Failed to write weights to device!")
	}
}

func iCloudWriteWeights() {
	let jsonEncoder = JSONEncoder()
	if let savedData = try? jsonEncoder.encode(weights) {
		let defaults = NSUbiquitousKeyValueStore.default
		defaults.set(savedData, forKey: "weights")
		defaults.synchronize()
	}
	else {
		NSLog("Failed to write weights to iCloud!")
	}
}
