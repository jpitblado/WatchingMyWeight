//
//  Entry.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation

class Entry : Codable {

	var weight: Double
	var date: Date

	init(weight: Double, date: Date) {
		self.weight = weight
		self.date = date
	}

	init(weight: Double) {
		self.weight = weight
		self.date = Date()
	}

}
