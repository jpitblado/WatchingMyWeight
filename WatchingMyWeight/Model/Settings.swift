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

	static let weight: Double = 150.0
}

enum Scale: String, Codable {
	case kg
	case lbs
}

enum NewWeight: String, Codable {
	case fixed
	case top
}

enum SettingType {
	case fontSize
	case weightDefault
	case newWeight
	case scale
}

struct Settings: Codable {
	// Cosmetic settings
	var fontSize: CGFloat = Defaults.fontSize

	// Weight settings
	var weightDefault: Double = Defaults.weight
	var newWeight: NewWeight = NewWeight.top
	var scale: Scale = Scale.lbs

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
