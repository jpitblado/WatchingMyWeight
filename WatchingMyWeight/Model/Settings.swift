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
	static let fontSizeMin: CGFloat = 20.0
	static let fontSizeMax: CGFloat = 48.0
	static let fontSizeStep: CGFloat = 2.0

	static let spacing: CGFloat = 0.25		// fraction of settings.fontSize

	static let weight: Double = 175.0

	static let lbs_per_kg = 2.20462
}

enum NewWeight: String, Codable {
	case Default
	case MostRecent
}

struct Settings: Codable {
	// Appearance
	var fontSize: CGFloat = Defaults.fontSize

	// Weight
	var weightDefault: Double = Defaults.weight
	var newWeight: NewWeight = NewWeight.MostRecent
	var units: Units = Units.lbs {
		didSet {
			weightDefault = weightValue(forWeight: weightDefault, inUnits: oldValue)
		}
	}

	func heightForLabel(withFontSize fontSize: CGFloat) -> CGFloat {
		return fontSize * (1.0 + 2*Defaults.spacing)
	}

	func heightForLabel() -> CGFloat {
		return heightForLabel(withFontSize: fontSize)
	}

	func heightForPicker() -> CGFloat {
		return 2*fontSize + 4*Defaults.spacing
	}

	func widthForWeightPicker() -> CGFloat {
		return 6*fontSize
	}

	func font(ofSize size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}

	func font() -> UIFont {
		return font(ofSize: fontSize)
	}

	func weightValue(forWeight weight: Double, inUnits units: Units) -> Double {
		if units == self.units {
			return weight
		}
		switch self.units {
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
			print("Failed to load settings!")
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
