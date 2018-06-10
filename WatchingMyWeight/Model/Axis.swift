//
//  axis.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 6/9/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

class Axis {

	// MARK: private properties

	private var minimum: CGFloat = 0.0
	private var maximum: CGFloat = 1.0

	private func tickStep(range: CGFloat, mostticks: Int) -> CGFloat {
		// Original source for the following logic is from the Python function named BestTick2 at https://stackoverflow.com/a/361687/4766139

		let minWidth = range / CGFloat(mostticks)
		let magnitude = CGFloat(pow(10.0, floor(log10(Double(minWidth)))))
		let residual = minWidth / magnitude

		var step: CGFloat = magnitude
		if residual >= 7.0 {
			step *= 10.0
		}
		else if residual >= 5.0 {
			step *= 7.0
		}
		else if residual >= 3.0 {
			step *= 5.0
		}
		else if residual >= 2.0 {
			step *= 3.0
		}
		else if residual >= 1.5 {
			step *= 2.0
		}
		else if residual >= 1.0 {
			step *= 1.5
		}

		return step
	}

	private func tickMin(min: CGFloat) -> CGFloat {
		if min == 0.0 {
			return min
		}

		var tick0 = min

		if min < 0.0 {
			tick0 = -tick0
		}
		tick0 = tickStep(range: tick0, mostticks: 1)
		if min < 0.0 {
			tick0 = -tick0
		}

		return tick0
	}

	// MARK: public properties

	var min: CGFloat {
		return minimum
	}

	var max: CGFloat {
		return maximum
	}

	var range: CGFloat {
		return maximum - minimum
	}

	var ticks = [CGFloat]()

	// MARK: initializer

	init(minValue: CGFloat, maxValue: CGFloat, marginRatio: CGFloat, maxTicks: Int) {
		reset(minValue:	minValue,
			  maxValue:	maxValue,
			  marginRatio: marginRatio,
			  maxTicks: maxTicks)
	}

	// MARK: public methods

	func reset(minValue: CGFloat, maxValue: CGFloat, marginRatio: CGFloat, maxTicks: Int) {
		let min = minValue
		var max = maxValue
		if maxValue < minValue {
			max = min
		}

		let range = max - min

		var margin = marginRatio * range
		if margin < 0.0 {
			margin = 0.0
		}

		var numTicks = maxTicks
		if numTicks < 1 {
			numTicks = 3
		}

		let step = tickStep(range: range, mostticks: numTicks)

		var tick = tickMin(min: min)
		minimum = tick - margin
		maximum = max + step
		ticks.removeAll()
		while tick < maximum {
			ticks.append(tick)
			tick += step
		}
		if ticks.count == 0 {
			ticks.append(tick)
			maximum = tick + margin
		}
		else {
			maximum = ticks[ticks.count-1] + margin
		}
	}

}
