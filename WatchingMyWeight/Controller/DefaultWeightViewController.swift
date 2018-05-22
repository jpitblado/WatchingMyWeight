//
//  DefaultWeightViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/8/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class DefaultWeightViewController: UIViewController {

	// MARK: outlets and actions

	@IBOutlet var pickerOutlet: UIPickerView!
	@IBOutlet var submitButton: UIButton!

	@IBAction func submitPressed(_ sender: UIButton) {
		settings.weightDefault = weightPicker?.value ?? Defaults.weight
		writeSettings()
		navigationController?.popViewController(animated: true)
	}

	// MARK: private data and methods

	private var pickerOutletHeightConstraint: NSLayoutConstraint?

	private var weightPicker: WeightPickerView!

	private func updateUI() {
		pickerOutletHeightConstraint?.constant = weightPicker.height
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Default Weight (\(settings.units))"

		weightPicker = WeightPickerView()
		pickerOutlet.dataSource = weightPicker
		pickerOutlet.delegate = weightPicker
		weightPicker?.set(fromWeight: settings.weightDefault, inUnits: settings.units)
		weightPicker?.update(pickerOutlet)

		pickerOutletHeightConstraint = pickerOutlet?.heightAnchor.constraint(equalToConstant: weightPicker.height)
		pickerOutletHeightConstraint?.isActive = true

		submitButton.titleLabel?.font = settings.font()

		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

}
