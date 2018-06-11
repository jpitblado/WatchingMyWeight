//
//  XYGraphViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/31/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class XYGraphViewController: UIViewController {

	// MARK: outlets

	@IBOutlet var xyGraphViewOutlet: XYGraphView!

	// MARK: private methods

	var debug: Bool = false

	private func updateUI() {
		if let step0 = steps.last {
			xyGraphViewOutlet.usingDates = true
			xyGraphViewOutlet.offsetTimeInterval = step0.date.timeIntervalSinceReferenceDate
			xyGraphViewOutlet.rescaleTimeInterval = TimeConstants.secondsPerDay
			xyGraphViewOutlet.usingDates = true
			xyGraphViewOutlet.newData()
			for step in steps {
				let x = step.date.timeIntervalSinceReferenceDate-step0.date.timeIntervalSinceReferenceDate
				xyGraphViewOutlet.addPoint(CGPoint(x: CGFloat(x/TimeConstants.secondsPerDay),
												   y: CGFloat(step.count)))
			}
		}
		xyGraphViewOutlet.plot()
	}

	// MARK: public methods

	func makeIdentityData(ofSize count: Int) {
		xyGraphViewOutlet.newData()
		for i in 0..<count {
			xyGraphViewOutlet.addPoint(CGPoint(x: i, y: i))
		}
	}

	func makeRandomData(ofSize count: Int) {
		xyGraphViewOutlet.newData()
		for _ in 0..<count {
			xyGraphViewOutlet.addPoint(randomPoint())
		}
	}

	func makeRandomData() {
		makeRandomData(ofSize: 3)
	}

	func makeSineData(ofSize count: Int) {
		xyGraphViewOutlet.newData()
		var x = -2.0*CGFloat.pi
		let delta = -x/CGFloat(count-1)
		for _ in 0..<count {
			xyGraphViewOutlet.addPoint(CGPoint(x: x, y: sin(x)))
			x += delta
		}
	}

	@objc
	func getData() {
		if debug {
//			makeRandomData(ofSize: 200)
//			makeIdentityData(ofSize: 5)
			makeSineData(ofSize: 50)
			xyGraphViewOutlet.plot()
		}
		else {
			updateUI()
		}
	}

	// MARK: loading

	override func viewDidLoad() {
		super.viewDidLoad()

		getData()
	}

}
