//
//  DefaultWeightViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/8/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class DefaultWeightViewController: UIViewController {

	// MARK: outlets

	@IBOutlet var pickerOutlet: UIPickerView!
	@IBOutlet var submitButton: UIButton!

	@IBAction func submitPressed(_ sender: UIButton) {
		settings.weightDefault = weightPicker?.value ?? Defaults.weight
		writeSettings()
		navigationController?.popViewController(animated: true)
	}

	// MARK: private data and methods

	private var pickerOutletHeightConstraint: NSLayoutConstraint?

	private var weightPicker: WeightPickerView?

	private func updateUI() {
		pickerOutlet?.frame.size.height = settings.heightForPicker()
		pickerOutletHeightConstraint?.constant = settings.heightForPicker()
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.title = "Default Weight (\(settings.weightScale))"

		weightPicker = WeightPickerView()
		pickerOutlet.dataSource = weightPicker
		pickerOutlet.delegate = weightPicker
		weightPicker?.set(fromWeight: settings.weightDefault, inScale: settings.weightScale)
		weightPicker?.update(pickerOutlet)

		pickerOutletHeightConstraint = pickerOutlet?.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		pickerOutletHeightConstraint?.isActive = true

		submitButton.titleLabel?.font = settings.font()

		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

}