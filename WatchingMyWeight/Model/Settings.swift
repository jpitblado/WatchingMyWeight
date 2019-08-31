//
//  Settings.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/6/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

struct Defaults {

	// MARK: constants

	static let weight: Double = 175.0

	static let lbs_per_kg = 2.20462

	static let randomSource = GKLinearCongruentialRandomSource()

}

func randomValue() -> CGFloat {
	return CGFloat(Defaults.randomSource.nextInt(upperBound: 100))/10.0
}

func randomPoint() -> CGPoint {
	return CGPoint(x: randomValue(), y: randomValue())
}

enum NewWeight: String, Codable {
	case Default = "Default"
	case MostRecent = "Most Recent"
	case Random = "Random"
}

enum DataStorage: String, Codable {
	case Local = "Local"
	case iCloud = "iCloud"
	case HealthApp = "HealthApp"
}

struct Settings: Codable {

	// MARK: properties

	// Appearance
	var fontName: String = ""

	// Weight Properties
	var weightDefault: Double = Defaults.weight
	var newWeight: NewWeight = NewWeight.MostRecent
	var units: Units = Units.lbs {
		didSet {
			weightDefault = weightValue(forWeight: weightDefault, inUnits: oldValue)
		}
	}

	// Data Storage
	var dataStorage: DataStorage = DataStorage.Local

	// MARK: methods

	func preferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
		return UIFont.preferredFont(forTextStyle: style)
	}

	func font(name: String, forTextStyle style: UIFont.TextStyle) -> UIFont {
		let pf = preferredFont(forTextStyle: style)

		if name != "" {
			if var font = UIFont(name: name, size: pf.pointSize) {
				let hr = pf.lineHeight / font.lineHeight
				if hr != 1.0 {
					if let altfont = UIFont(name: name, size: pf.pointSize*hr) {
						font = altfont
					}
				}
				let metrics = UIFontMetrics(forTextStyle: style)
				return metrics.scaledFont(for: font)
			}
		}

		return pf
	}

	func font(forTextStyle style: UIFont.TextStyle) -> UIFont {
		return font(name: fontName, forTextStyle: style)
	}

	func font() -> UIFont {
		return font(forTextStyle: .body)
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

	func randomWeightValue() -> Double {
		return weightDefault + Double(Defaults.randomSource.nextInt(upperBound: 101) - 50)/10.0
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
			NSLog("Failed to load settings!")
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
		NSLog("Failed to save settings!")
	}
}
