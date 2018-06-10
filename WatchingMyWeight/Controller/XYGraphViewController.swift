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

	@objc
	func getData() {
		if debug {
//			xyGraphViewOutlet.makeRandomData(ofSize: 200)
//			xyGraphViewOutlet.makeIdentityData(ofSize: 5)
			xyGraphViewOutlet.makeSineData(ofSize: 50)
			xyGraphViewOutlet.plot()
		}
		else {
			updateUI()
		}
	}

	// MARK: loading

	override func viewDidLoad() {
		super.viewDidLoad()

		// dataSetup
		getData()
	}

}
