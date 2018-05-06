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

	// spacing is measured as a fraction of settings.fontSize
	static let spacing: CGFloat = 0.25

	static let weight: Double = 125.0
}

struct Settings {
	var fontSize: CGFloat = Defaults.fontSize
	var weightDefault: Double = Defaults.weight
}

var settings = Settings(fontSize: Defaults.fontSize,
						weightDefault: Defaults.weight)
