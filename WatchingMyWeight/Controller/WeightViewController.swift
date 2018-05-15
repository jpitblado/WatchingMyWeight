//
//  WeightViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/5/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController {

	// MARK: outlets and actions

	@IBOutlet var weightsRecordedLabel: UILabel!

	@IBOutlet var weightLabel: UILabel!
	@IBOutlet var weightPickerOutlet: UIPickerView!

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var datePicker: UIDatePicker!

	@IBOutlet var button: UIButton!

	@IBAction func buttonPressed(_ sender: UIButton) {
		let weight = weightPicker.value
		let date = datePicker.date
		if let indexPath = fromIndexPath {
			weights[indexPath.row].weight = weight
			weights[indexPath.row].date = date
			weights[indexPath.row].units = settings.units
		}
		else {
			let newWeight = Weight(weight: weight, units: settings.units, date: date)
			weights.insert(newWeight, at: 0)
			added += 1
		}
		writeWeights()
		updateUI()
		if added == 0 {
			navigationController?.popViewController(animated: true)
		}
	}

	// MARK: private poperties and methods

	private var added: Int = 0

	private var weightPicker: WeightPickerView!

	private var weightPickerOutletHeightConstraint: NSLayoutConstraint?
	private var weightPickerOutletWidthConstraint: NSLayoutConstraint?
	private var datePickerOutletHeightConstraint: NSLayoutConstraint?

	private func randomizeWeightPicker() {
		var weight = settings.randomWeightValue()

		if weight < 0.0 {
			weight = 0.0
		}
		else if weight > 999.9 {
			weight = 999.9
		}
		weightPicker.set(fromWeight: weight, inUnits: settings.units)
	}

	private func updateUI() {
		if fromIndexPath == nil {
			if added > 0 {
				if added == 1 {
					weightsRecordedLabel.text = "Weight Added"
				}
				else {
					weightsRecordedLabel.text = "\(added) Weights Added"
				}
				weightsRecordedLabel.isHidden = false
				if settings.newWeight == .Random {
					randomizeWeightPicker()
					weightPicker.update(weightPickerOutlet)
				}
			}
		}

		weightLabel?.frame.size.height = settings.heightForPicker()
		weightPickerOutlet?.frame.size.height = settings.heightForPicker()
		weightPickerOutletHeightConstraint?.constant = settings.heightForPicker()
		weightPickerOutletWidthConstraint?.constant = settings.widthForWeightPicker()

		dateLabel?.frame.size.height = settings.heightForPicker()
		datePickerOutletHeightConstraint?.constant = settings.heightForPicker()
	}

	// MARK: public properties

	var fromIndexPath: IndexPath?

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		weightsRecordedLabel.font = settings.font(ofSize: settings.fontSize*0.8)
		weightsRecordedLabel.textColor = UIColor.lightGray
		weightsRecordedLabel.isHidden = true

		weightLabel.font = settings.font()
		weightLabel.text = "Weight (\(settings.units))"
		weightPicker = WeightPickerView()
		weightPickerOutlet.delegate = weightPicker
		weightPickerOutlet.dataSource = weightPicker

		dateLabel.font = settings.font()

		if let indexPath = fromIndexPath {
			weightPicker.set(fromWeight: weights[indexPath.row].weight, inUnits: weights[indexPath.row].units)
			datePicker.date = weights[indexPath.row].date
			navigationItem.title = "Edit Weight Data"
			button.setTitle("Submit", for: .normal)
		}
		else {
			switch settings.newWeight {
			case .Default:
				weightPicker.set(fromWeight: settings.weightDefault, inUnits: settings.units)
			case .MostRecent:
				if weights.count > 0 {
					weightPicker.set(fromWeight: weights[0].weight, inUnits: weights[0].units)
				}
				else {
					weightPicker.set(fromWeight: settings.weightDefault, inUnits: settings.units)
				}
			case .Random:
				randomizeWeightPicker()
			}
			// datePicker defaults to current date/time
			navigationItem.title = "Add Weight Data"
			button.setTitle("Add", for: .normal)
		}
		weightPicker.update(weightPickerOutlet)

		button.titleLabel?.font = settings.font()

		weightPickerOutletHeightConstraint = weightPickerOutlet?.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		weightPickerOutletHeightConstraint?.isActive = true
		weightPickerOutletWidthConstraint = weightPickerOutlet?.widthAnchor.constraint(equalToConstant: settings.widthForWeightPicker())
		weightPickerOutletWidthConstraint?.isActive = true

		datePickerOutletHeightConstraint = datePicker.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		datePickerOutletHeightConstraint?.isActive = true
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

}
