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

enum Defaults {
	static let fontSize: CGFloat = 24.0
	static let uiFontSize: CGFloat = 28.0

	static let spacing: CGFloat = 0.5		// fraction of font size

	static let weight: Double = 175.0

	static let lbs_per_kg = 2.20462

	static let randomSource = GKLinearCongruentialRandomSource()
}

enum NewWeight: String, Codable {
	case Default = "Default"
	case MostRecent = "Most Recent"
	case Random = "Random"
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
		return fontSize * (1.0 + 2.0*Defaults.spacing)
	}

	func heightForLabel() -> CGFloat {
		return heightForLabel(withFontSize: fontSize)
	}

	func heightForPicker() -> CGFloat {
		return heightForLabel(withFontSize: fontSize)
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
