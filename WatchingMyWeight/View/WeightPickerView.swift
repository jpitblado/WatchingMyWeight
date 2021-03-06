//
//  WeightPickerView.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/6/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class WeightPickerView: UIPickerView {

	// MARK: private properties

	private var digits = ["0","0","0",".","0"]
	private let dotComponent = 3

	// MARK: public properties

	var value : Double {
		get {
			return Double(digits.joined(separator: "")) ?? 0.0
		}
	}

	var height: CGFloat {
		get {
			let font = settings.font()
			return font.lineHeight*2.5
		}
	}

	var width: CGFloat {
		get {
			let font = settings.font()
			return font.lineHeight*10.0
		}
	}

	// MARK: public methods

	func set(fromWeight weight: Double, inUnits units: Units) {
		let w = settings.weightValue(forWeight: weight, inUnits: units)
		var w10 = Int(round(w * 10.0))
		var pos = digits.count
		for _ in 0..<digits.count {
			pos -= 1
			if (pos == dotComponent) {
				continue
			}
			digits[pos] = String(w10 % 10)
			w10 = w10/10
		}
	}

	func update(_ pickerView: UIPickerView) {
		for pos in 0..<digits.count {
			if (pos == dotComponent) {
				continue
			}
			pickerView.selectRow(Int(digits[pos])!, inComponent: pos, animated: true)
		}
		pickerView.reloadAllComponents()
	}

}

extension WeightPickerView: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		// hide the lines that delimit the picked row
		/*
		pickerView.subviews.forEach {
			$0.isHidden = $0.frame.height < 1.0
		}
		*/

		return digits.count
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == dotComponent {
			// just the dot
			return 1
		}
		// digits
		return 10
	}

}

extension WeightPickerView: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		let font = settings.font()
		return font.lineHeight*2.0
	}

	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		let font = settings.font()
		if component == dotComponent {
			return font.lineHeight
		}
		return font.lineHeight*2.0
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
		}
		pickerLabel?.font = settings.font()

		if component == dotComponent {
			pickerLabel?.text = "."
		}
		else {
			pickerLabel?.text = String(row)
		}
		pickerLabel?.textAlignment = NSTextAlignment.center

		return pickerLabel!
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component != dotComponent {
			digits[component] = String(row)
		}
	}

}

