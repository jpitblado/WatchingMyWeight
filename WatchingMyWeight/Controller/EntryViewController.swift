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
			weights[indexPath.row].weight = weight
			weights[indexPath.row].date = date
			weights[indexPath.row].units = settings.units
		}
		else {
			let newEntry = Weight(weight: weight, units: settings.units, date: date)
//			let newEntry = Entry(weight: weight, date: date)
			weights.insert(newEntry, at: 0)
		}
		writeEntries()
		navigationController?.popViewController(animated: true)
	}

	var weightPickerOutletHeightConstraint: NSLayoutConstraint?
	var weightPickerOutletWidthConstraint: NSLayoutConstraint?
	var datePickerOutletHeightConstraint: NSLayoutConstraint?

	override func viewDidLoad() {
		super.viewDidLoad()

		weightLabel.font = settings.font()
		weightLabel.text = "Weight (\(settings.units))"
		weightPicker = WeightPickerView()
		weightPickerOutlet.delegate = weightPicker
		weightPickerOutlet.dataSource = weightPicker

		dateLabel.font = settings.font()

		submitButton.titleLabel?.font = settings.font()

		if let indexPath = fromIndexPath {
			weightPicker.set(fromWeight: weights[indexPath.row].weight, inUnits: weights[indexPath.row].units)
			datePicker.date = weights[indexPath.row].date
			navigationItem.title = "Edit"
			submitButton.setTitle("Submit changes", for: .normal)
		}
		else {
			if weights.count > 0 && settings.newWeight == NewWeight.MostRecent {
				weightPicker.set(fromWeight: weights[0].weight, inUnits: weights[0].units)
			}
			else {
				weightPicker.set(fromWeight: settings.weightDefault, inUnits: settings.units)
			}
			// datePicker defaults to current date/time
			navigationItem.title = "Add"
			submitButton.setTitle("Submit new data", for: .normal)
		}
		weightPicker.update(weightPickerOutlet)

		weightPickerOutletHeightConstraint = weightPickerOutlet?.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		weightPickerOutletHeightConstraint?.isActive = true
		weightPickerOutletWidthConstraint = weightPickerOutlet?.widthAnchor.constraint(equalToConstant: settings.widthForWeightPicker())
		weightPickerOutletWidthConstraint?.isActive = true
		// weightPickerOutlet?.backgroundColor = UIColor.green		// !! debug

		datePickerOutletHeightConstraint = datePicker.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		datePickerOutletHeightConstraint?.isActive = true

		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

	func updateUI() {
		weightLabel?.frame.size.height = settings.heightForPicker()
		weightPickerOutlet?.frame.size.height = settings.heightForPicker()
		weightPickerOutletHeightConstraint?.constant = settings.heightForPicker()
		weightPickerOutletWidthConstraint?.constant = settings.widthForWeightPicker()

		dateLabel?.frame.size.height = settings.heightForPicker()
		datePickerOutletHeightConstraint?.constant = settings.heightForPicker()
	}

}
