//
//  EntryViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/5/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

	var fromIndexPath: IndexPath?

	@IBOutlet var weightLabel: UILabel!
	@IBOutlet var weightPickerOutlet: UIPickerView!
	var weightPicker: WeightPickerView!

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var datePicker: UIDatePicker!

	@IBOutlet var submitButton: UIButton!

	@IBAction func submitPressed(_ sender: UIButton) {
		let weight = weightPicker.value
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

	override func viewDidLoad() {
        super.viewDidLoad()

		weightLabel.font = UIFont.systemFont(ofSize: settings.fontSize)
		weightPicker = WeightPickerView()
		weightPickerOutlet.delegate = weightPicker
		weightPickerOutlet.dataSource = weightPicker

		dateLabel.font = UIFont.systemFont(ofSize: settings.fontSize)
		submitButton.titleLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)

		if let indexPath = fromIndexPath {
			weightPicker.setDigits(fromWeight: entries[indexPath.row].weight)
			datePicker.date = entries[indexPath.row].date
			navigationItem.title = "Edit"
			submitButton.setTitle("Submit changes", for: .normal)
		}
		else {
			if entries.count > 0 && settings.newWeight == NewWeight.top {
				weightPicker.setDigits(fromWeight: entries[0].weight)
			}
			else {
				weightPicker.setDigits(fromWeight: settings.weightDefault)
			}
			// datePicker defaults to current date/time
			navigationItem.title = "Add"
			submitButton.setTitle("Submit new data", for: .normal)
		}
		weightPicker.update(weightPickerOutlet)
    }

}
