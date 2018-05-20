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

	static let fontSize: CGFloat = 24.0
	static let ipadFontSize: CGFloat = 24.0
	static let iphoneFontSize: CGFloat = 22.0

	static let spacing: CGFloat = 0.5		// fraction of font size

	static let weight: Double = 175.0

	static let lbs_per_kg = 2.20462

	static let randomSource = GKLinearCongruentialRandomSource()

	// MARK: methods

	static func uiFontSize() -> CGFloat {
		if Device.is_iphone {
			return iphoneFontSize
		}
		return ipadFontSize
	}

	static func uiFont() -> UIFont {
		if Device.is_iphone {
			return UIFont.systemFont(ofSize: iphoneFontSize)
		}
		return UIFont.systemFont(ofSize: ipadFontSize)
	}

}

enum NewWeight: String, Codable {
	case Default = "Default"
	case MostRecent = "Most Recent"
	case Random = "Random"
}

struct Settings: Codable {

	// MARK: properties

	// Appearance
	var fontSize: CGFloat = Defaults.fontSize
	var fontName: String = ""

	// Weight
	var weightDefault: Double = Defaults.weight
	var newWeight: NewWeight = NewWeight.MostRecent
	var units: Units = Units.lbs {
		didSet {
			weightDefault = weightValue(forWeight: weightDefault, inUnits: oldValue)
		}
	}

	// MARK: methods

	func heightForLabel(withFontSize fontSize: CGFloat) -> CGFloat {
		return fontSize * (1.0 + 2.0*Defaults.spacing)
	}

	func heightForLabel() -> CGFloat {
		return heightForLabel(withFontSize: fontSize)
	}

	func heightForPicker() -> CGFloat {
		return heightForLabel(withFontSize: fontSize*1.25)
	}

	func widthForWeightPicker() -> CGFloat {
		return 6*fontSize
	}

	func systemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}

	func systemFont() -> UIFont {
		return systemFont(ofSize: fontSize)
	}

	func font(ofSize size: CGFloat) -> UIFont {
		if fontName == "" {
			return UIFont.systemFont(ofSize: size)
		}
		if let font = UIFont(name: fontName, size: size) {
			let ratio = UIFont.systemFont(ofSize: size).lineHeight / font.lineHeight
			if ratio != 1.0 {
				if let altFont = UIFont(name: fontName, size: size*ratio) {
					return altFont
				}
			}
			return font
		}
		return UIFont.systemFont(ofSize: size)
	}

	func font() -> UIFont {
		return font(ofSize: fontSize)
	}

	func uiFont() -> UIFont {
		return font(ofSize: Defaults.uiFontSize())
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
