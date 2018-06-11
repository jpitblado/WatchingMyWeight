//
//  XYGraphView.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/31/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class XYGraphView: UIView {

	// MARK: private properties and methods

	private var data = [CGPoint]()

	private var dataMin = CGPoint(x: 0.0, y: 0.0)
	private var dataMax = CGPoint(x: 1.0, y: 1.0)

	private var xAxis = Axis(minValue: 0, maxValue: 1, marginRatio: 0, maxTicks: 11)
	private var xAxisLabels = [UILabel]()

	private var yAxis = Axis(minValue: 0, maxValue: 1, marginRatio: 0, maxTicks: 11)
	private var yAxisLabels = [UILabel]()

	private let maxTicks: Int = 5
	private let tickSize: CGFloat = 5.0
	private var grid: Bool = false

	private var drawMargin: CGPoint {
		return CGPoint(x: marginSize, y: marginSize)
	}

	private var drawScale: CGVector {
		return CGVector(dx: bounds.size.width - 2 * marginSize, dy: bounds.size.height - 2 * marginSize)
	}

	// MARK: public methods

	var usingDates: Bool = false
	var offsetTimeInterval: Double = 0.0
	var rescaleTimeInterval: Double = 1.0

	func newData() {
		data.removeAll()
	}

	func addPoint(_ point: CGPoint) {
		data.append(point)
		if data.count == 1 {
			dataMin = point
			dataMax = point
			return
		}
		if point.x < dataMin.x {
			dataMin.x = point.x
		}
		else if point.x > dataMax.x {
			dataMax.x = point.x
		}
		if point.y < dataMin.y {
			dataMin.y = point.y
		}
		else if point.y > dataMax.y {
			dataMax.y = point.y
		}
	}

	// MARK: drawing

	func plot() {
		xAxis.reset(minValue: dataMin.x,
					maxValue: dataMax.x,
					marginRatio: Constants.axisMarginRatio,
					maxTicks: maxTicks)
		yAxis.reset(minValue: dataMin.y,
					maxValue: dataMax.y,
					marginRatio: Constants.axisMarginRatio,
					maxTicks: maxTicks)

		setNeedsLayout()
		setNeedsDisplay()
	}

	private func translatePoint(_ point: CGPoint) -> CGPoint {
		// x position is drawn left to right
		let x: CGFloat = (point.x - xAxis.min) * drawScale.dx / xAxis.range + drawMargin.x

		// y position is drawn top to bottom
		let y: CGFloat = (yAxis.max - point.y) * drawScale.dy / yAxis.range + drawMargin.y

		return CGPoint(x: x, y: y)
	}

	func configureXAxisLabel(_ label: UILabel, forValue value: CGFloat) {
		if usingDates {
			let date = Date(timeIntervalSinceReferenceDate: offsetTimeInterval + Double(value)*rescaleTimeInterval)
			let dateFmt = DateFormatter()
			dateFmt.dateStyle = DateFormatter.Style.short
			configureLabel(label, withText: dateFmt.string(from: date))
		}
		else {
			configureNumericLabel(label, forValue: value)
		}
	}

	func configureYAxisLabel(_ label: UILabel, forValue value: CGFloat) {
		configureNumericLabel(label, forValue: value)
	}

	private func layoutAxes() {
		var point: CGPoint
		var numTicks: Int

		let axisLabelMargin: CGFloat = 5.0

		// reset X axis labels
		for x in xAxisLabels {
			x.removeFromSuperview()
		}
		xAxisLabels.removeAll()

		// layout for X axis labels
		numTicks = xAxis.ticks.count
		for i in 0..<numTicks {
			let newTickLabel = createLabel()
			configureXAxisLabel(newTickLabel, forValue: xAxis.ticks[i])
			point = CGPoint(x: xAxis.ticks[i], y: yAxis.min)
			point = translatePoint(point)
			point = point.offsetBy(dx: -newTickLabel.bounds.size.width/2.0, dy: axisLabelMargin)
			newTickLabel.frame.origin = point
			xAxisLabels.append(newTickLabel)
		}

		// reset Y axis labels
		for y in yAxisLabels {
			y.removeFromSuperview()
		}
		yAxisLabels.removeAll()

		// layout for Y axis labels
		numTicks = yAxis.ticks.count
		for i in 0..<numTicks {
			let newTickLabel = createLabel()
			configureYAxisLabel(newTickLabel, forValue: yAxis.ticks[i])
			point = CGPoint(x: xAxis.min, y: yAxis.ticks[i])
			point = translatePoint(point)
			point = point.offsetBy(dx: -newTickLabel.bounds.width - axisLabelMargin, dy: -newTickLabel.bounds.size.height/2.0)
			newTickLabel.frame.origin = point
			yAxisLabels.append(newTickLabel)
		}
	}

	override func layoutSubviews() {
		layoutAxes()
		super.layoutSubviews()
	}

	private func drawAxisTicks() {
		var point: CGPoint
		var numTicks: Int

		// X axis ticks/grid
		numTicks = xAxis.ticks.count
		for i in 0..<numTicks {
			point = CGPoint(x: xAxis.ticks[i], y: yAxis.min)
			point = translatePoint(point)
			let path = UIBezierPath()
			path.move(to: point)
			if grid {
				point = CGPoint(x: xAxis.ticks[i], y: yAxis.max)
				point = translatePoint(point)
				path.addLine(to: point)
				path.lineWidth = 1.0
				UIColor.gray.setStroke()
			}
			else {
				path.addLine(to: point.offsetBy(dx: 0, dy: -tickSize))
				path.lineWidth = 2.0
				UIColor.black.setStroke()
			}
			path.stroke()
		}

		// Y axis ticks/grid
		numTicks = yAxis.ticks.count
		for i in 0..<numTicks {
			point = CGPoint(x: xAxis.min, y: yAxis.ticks[i])
			point = translatePoint(point)
			let path = UIBezierPath()
			path.move(to: point)
			if grid {
				point = CGPoint(x: xAxis.max, y: yAxis.ticks[i])
				point = translatePoint(point)
				path.addLine(to: point)
				path.lineWidth = 1.0
				UIColor.gray.setStroke()
			}
			else {
				path.addLine(to: point.offsetBy(dx: tickSize, dy: 0))
				path.addLine(to: point)
				path.lineWidth = 2.0
				UIColor.black.setStroke()
			}
			path.stroke()
		}
	}

	private func drawPoint(_ point: CGPoint) {
		let mypoint = translatePoint(point)

		// marker symbol
		let path = UIBezierPath()
		path.addArc(withCenter: mypoint,
					radius: pointRadius,
					startAngle: 0,
					endAngle: Constants.twoPi,
					clockwise: true)
		path.lineWidth = 1.0
		UIColor.red.setStroke()
		path.stroke()
	}

	private func plotPoints() {
		for point in data {
			drawPoint(point)
		}
	}

	private func connectPoints() {
		var point: CGPoint
		let path = UIBezierPath()
		path.lineWidth = 2.0
		for i in 0..<data.count {
			point = translatePoint(data[i])
			if i == 0 {
				path.move(to: point)
			}
			else {
				path.addLine(to: point)
			}
		}
		UIColor.green.setStroke()
		path.stroke()
	}

	override func draw(_ rect: CGRect) {
		// axis boundary
		let rect = UIBezierPath(rect: bounds.insetBy(dx: marginSize, dy: marginSize))
		UIColor.black.setStroke()
		rect.lineWidth = 2.0
		rect.stroke()

		connectPoints()
		plotPoints()
		drawAxisTicks()
	}

}

extension XYGraphView {
	private struct Constants {
		static let twoPi: CGFloat = 2.0*CGFloat.pi

		static let pointRadiusToBoundsMin: CGFloat = 0.01

		static let graphMarginRatio: CGFloat = 0.1

		static let axisMarginRatio: CGFloat = 0.05
	}

	private var pointRadius: CGFloat {
		if bounds.size.width < bounds.size.height {
			return bounds.size.width * Constants.pointRadiusToBoundsMin
		}
		return bounds.size.height * Constants.pointRadiusToBoundsMin
	}

	private var marginSize: CGFloat {
		if bounds.size.width < bounds.size.height {
			return bounds.size.width * Constants.graphMarginRatio
		}
		return bounds.size.height * Constants.graphMarginRatio
	}
}

