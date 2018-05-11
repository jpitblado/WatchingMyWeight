//
//  NewWeightPickerView.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/9/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class NewWeightPickerView: UIPickerView {

	private var newWeight = NewWeight.top

	var value : NewWeight {
		get {
			return newWeight
		}
	}

	func set(fromNewWeight nw: NewWeight) {
		newWeight = nw
	}

	func update(_ pickerView: UIPickerView) {
		switch newWeight {
		case .fixed:
			pickerView.selectRow(0, inComponent: 0, animated: true)
		case .top:
			pickerView.selectRow(1, inComponent: 0, animated: true)
		}
	}

}

extension NewWeightPickerView: UIPickerViewDataSource {

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

extension NewWeightPickerView: UIPickerViewDelegate {

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
			pickerLabel?.text = "Default Weight"
		}
		else {
			pickerLabel?.text = "Most Recent Weight"
		}
		pickerLabel?.textAlignment = .center

		return pickerLabel!
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if row == 0 {
			newWeight = .fixed
		}
		else {
			newWeight = .top
		}
	}

}
