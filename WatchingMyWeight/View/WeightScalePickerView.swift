//
//  WeightScalePickerView.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/10/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class WeightScalePickerView: UIPickerView {

	private var weightScale = WeightScale.lbs

	var value : WeightScale {
		get {
			return weightScale
		}
	}

	func set(fromWeightScale ws: WeightScale) {
		weightScale = ws
	}

	func update(_ pickerView: UIPickerView) {
		switch weightScale {
		case .kg:
			pickerView.selectRow(0, inComponent: 0, animated: true)
		case .lbs:
			pickerView.selectRow(1, inComponent: 0, animated: true)
		}
	}

}

extension WeightScalePickerView: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		// hide the lines that delimit the picked row
		/*
		pickerView.subviews.forEach {
		$0.isHidden = $0.frame.height < 1.0
		}
		*/

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 2
	}

}

extension WeightScalePickerView: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return settings.heightForLabel()
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.font = settings.font()
		}

		if row == 0 {
			pickerLabel?.text = "Kilograms (kg)"
		}
		else {
			pickerLabel?.text = "Pounds (lbs)"
		}
		pickerLabel?.textAlignment = .center

		return pickerLabel!
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			weightScale = .kg
		}
		else {
			weightScale = .lbs
		}
	}

}

