//
//  Settings.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/6/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

enum Defaults {
	static let fontSize: CGFloat = 24.0
	static let spacing: CGFloat = 0.25		// fraction of settings.fontSize

	static let weight: Double = 175.0

	static let lbs_per_kg = 2.20462
}

enum WeightScale: String, Codable {
	case kg = "kg"
	case lbs = "lbs"
}

enum NewWeight: String, Codable {
	case fixed
	case top
}

enum SettingType {
	case fontSize
	case weightDefault
	case newWeight
	case weightScale
}

struct Settings: Codable {
	// Cosmetic settings
	var fontSize: CGFloat = Defaults.fontSize

	// Weight settings
	var weightDefault: Double = Defaults.weight
	var newWeight: NewWeight = NewWeight.top
	var weightScale: WeightScale = WeightScale.lbs {
		didSet {
			weightDefault = weightValue(forWeight: weightDefault, inScale: oldValue)
		}
	}

	func heightForLabel() -> CGFloat {
		return fontSize * (1.0 + 2*Defaults.spacing)
	}

	func heightForPicker() -> CGFloat {
		return 2*fontSize + 4*Defaults.spacing
	}

	func widthForWeightPicker() -> CGFloat {
		return 6*fontSize
	}

	func font() -> UIFont {
		return UIFont.systemFont(ofSize: fontSize)
	}

	func weightValue(forWeight weight: Double, inScale weightScale: WeightScale) -> Double {
		if weightScale == self.weightScale {
			return weight
		}
		switch self.weightScale {
		case .kg:
			return weight/Defaults.lbs_per_kg
		case .lbs:
			return weight*Defaults.lbs_per_kg
		}
	}

}

var settings = Settings()

func readSettings() {
	let defaults = UserDefaults.standard

	if let savedData = defaults.object(forKey: "settings") as? Data {
		let jsonDecoder = JSONDecoder()

		do {
			settings = try jsonDecoder.decode(Settings.self, from: savedData)
		}
		catch {
			print("Failed to load entries!")
		}
	}
}

func writeSettings() {
	let jsonEncoder = JSONEncoder()
	if let savedData = try? jsonEncoder.encode(settings) {
		let defaults = UserDefaults.standard
		defaults.set(savedData, forKey: "settings")
	}
	else {
		print("Failed to save settings!")
	}
}
