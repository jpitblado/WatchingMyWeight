//
//  Step.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/25/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation

struct Step : Codable {
	var count : Int
	var date : Date
}

var steps = [Step]()

func sortSteps() {
	steps.sort {
		return $0.date > $1.date
	}
}
