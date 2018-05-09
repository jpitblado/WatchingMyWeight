//
//  FontPickerView.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/8/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class FontSizePickerView: UIPickerView {

	private let minSize: CGFloat = 20.0
	private let maxSize: CGFloat = 48.0
	private let stepSize: CGFloat = 2.0
	private var curSize: CGFloat = 24.0

	var value : CGFloat {
		get {
			return curSize
		}
	}

	func set(fromFontSize fontSize: CGFloat) {
		curSize = fontSize
	}

	func update(_ pickerView: UIPickerView) {
		let row: Int = Int((curSize - minSize)/stepSize)
		pickerView.selectRow(row, inComponent: 0, animated: true)
	}

}

extension FontSizePickerView: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		// hide the lines that delimit the picked row
		pickerView.subviews.forEach {
			$0.isHidden = $0.frame.height < 1.0
		}

		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		let rows = Int((maxSize - minSize)/stepSize) + 1
		return rows
	}

}

extension FontSizePickerView: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return settings.heightForFontSize()
	}

	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return 5*settings.fontSize
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.font = settings.font()
		}

		let rowSize = minSize + CGFloat(row)*stepSize
		pickerLabel?.text = String(format: "%.1f", rowSize)
		pickerLabel?.textAlignment = .center

		return pickerLabel!
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		curSize = minSize + CGFloat(row)*stepSize
	}

}
