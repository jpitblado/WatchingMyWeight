//
//  XYGraphViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/31/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class XYGraphViewController: UIViewController {

	var showingInfo: Bool = false
	var infoLabel = UILabel()

	// MARK: outlets

	@IBOutlet var xyGraphViewOutlet: XYGraphView! {
		didSet {
			let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
			tap.numberOfTapsRequired = 1
			tap.numberOfTouchesRequired = 1
			xyGraphViewOutlet.addGestureRecognizer(tap)
		}
	}

	private func infoForDataAt(index i: Int) -> String {
		if debug || i < 0 || i >= steps.count {
			return ""
		}
		let info = steps[i]

		let dateFmt = DateFormatter()
		dateFmt.dateStyle = DateFormatter.Style.short
		let xString = dateFmt.string(from: info.date)

		let fmt = NumberFormatter()
		fmt.numberStyle = NumberFormatter.Style.decimal
		fmt.maximumFractionDigits = 2
		let yString = fmt.string(from: NSNumber(value: Float(info.count))) ?? "\(info.count)"
		return xString + "\n" + yString
	}

	@objc func didTap(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: xyGraphViewOutlet)
		if let i = xyGraphViewOutlet.indexFor(xValue: location.x) {
			if showingInfo {
				infoLabel.isHidden = true
				showingInfo = false
				return
			}
			view.configureLabel(infoLabel, withText: infoForDataAt(index: i))
			var loc = xyGraphViewOutlet.locationAt(index: i)
			loc = loc.offsetBy(dx: xyGraphViewOutlet.frame.origin.x, dy: xyGraphViewOutlet.frame.origin.y)
			loc = loc.offsetBy(dx: -infoLabel.frame.width/2.0, dy: -infoLabel.frame.height)
			infoLabel.frame.origin = loc
			infoLabel.isHidden = false
			showingInfo = true
		}
	}

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

		infoLabel.textAlignment = .center
		infoLabel.numberOfLines = 0
		infoLabel.isHidden = true
		view.addSubview(infoLabel)

		getData()
	}

}
