//
//  EntryViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/5/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	var fromIndexPath: IndexPath?

	@IBOutlet var weightLabel: UILabel!
	@IBOutlet var weightPicker: UIPickerView!

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var datePicker: UIDatePicker!

	@IBOutlet var submitButton: UIButton!
	
	var weightDigits = ["0","0","0",".","0"]
	let weightPickerDim = 5

	@IBAction func submitPressed(_ sender: UIButton) {
		let weight = Double(weightDigits.joined(separator: "")) ?? 0.0
		let date = datePicker.date
		if let indexPath = fromIndexPath {
			entries[indexPath.row].weight = weight
			entries[indexPath.row].date = date
		}
		else {
			let newEntry = Entry(weight: weight, date: date)
			entries.insert(newEntry, at: 0)
		}
		writeEntries()
		navigationController?.popViewController(animated: true)
	}

	func updateWeightPicker() {
		var pos = weightPickerDim
		for i in 0..<weightPickerDim {
			pos -= 1
			if (i == 1) {
				continue
			}
			weightPicker.selectRow(Int(weightDigits[pos])!, inComponent: pos, animated: true)
		}
	}

	func setWeightDigits(fromWeight weight: Double) {
		var w10 = Int(weight * 10.0)
		var pos = weightPickerDim
		for i in 0..<weightPickerDim {
			pos -= 1
			if (i == 1) {
				continue
			}
			weightDigits[pos] = String(w10 % 10)
			w10 = w10/10
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()

		weightPicker.delegate = self
		weightPicker.dataSource = self

		weightLabel.font = UIFont.systemFont(ofSize: settings.fontSize)
		dateLabel.font = UIFont.systemFont(ofSize: settings.fontSize)
		submitButton.titleLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)

		if let indexPath = fromIndexPath {
			setWeightDigits(fromWeight: entries[indexPath.row].weight)
			datePicker.date = entries[indexPath.row].date
			navigationItem.title = "Edit"
			submitButton.setTitle("Submit changes", for: .normal)
		}
		else if entries.count > 0 {
			setWeightDigits(fromWeight: entries[0].weight)
			// datePicker defaults to current date/time
			navigationItem.title = "Add"
			submitButton.setTitle("Submit new data", for: .normal)
		}
		else {
			weightDigits = ["1", "2", "5", ".", "0"]
			// datePicker defaults to current date/time
			navigationItem.title = "Add"
			submitButton.setTitle("Submit new data", for: .normal)
		}
		updateWeightPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
//		pickerView.subviews.forEach {
//			$0.isHidden = $0.frame.height < 1.0
//		}
		return weightPickerDim
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 3 {
			return 1
		}
		return 10
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		weightDigits[component] = String(row)
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 3 {
			return "."
		}
		return String(row)
	}

/*
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		if component == 3 {
			return 24
		}
		return 24
	}

	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.font = UIFont(name: "System", size: 48)
			pickerLabel?.font = UIFont.systemFont(ofSize: 28)
		}
		if component == 3 {
			pickerLabel?.text = "."
		}
		else {
			pickerLabel?.text = " " + String(row)
		}
		return pickerLabel!
	}
*/

}
