//
//  SettingDetailViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/8/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController {

	// Date label
	@IBOutlet var settingDescriptionLabel: UILabel!
	@IBOutlet var pickerOutlet: UIPickerView!
	@IBOutlet var submitButton: UIButton!

	@IBAction func submitPressed(_ sender: UIButton) {
		switch settingType {
		case .fontSize:
			print("!!! should not happen !!!")
		case .weightDefault:
			settings.weightDefault = weightPicker?.value ?? Defaults.weight
		case .newWeight:
			print("!!! should not happen !!!")
		case .weightScale:
			print("!!! should not happen !!!")
		}
		writeSettings()
		navigationController?.popViewController(animated: true)
	}

	var pickerOutletHeightConstraint: NSLayoutConstraint?

	var weightPicker: WeightPickerView?

	var settingName: String = ""
	var settingType: SettingType = SettingType.fontSize

	override func viewDidLoad() {
		super.viewDidLoad()

		settingDescriptionLabel.font = settings.font()

		navigationItem.title = settingName
		switch settingType {
		case .fontSize:
			print("!!! should not happen !!!")
		case .weightDefault:
			weightPicker = WeightPickerView()
			pickerOutlet.dataSource = weightPicker
			pickerOutlet.delegate = weightPicker
			weightPicker?.set(fromWeight: settings.weightDefault, inScale: settings.weightScale)
			weightPicker?.update(pickerOutlet)
			settingDescriptionLabel.text = "Change the \(settingName) (\(settings.weightScale))"
		case .newWeight:
			print("!!! should not happen !!!")
		case .weightScale:
			print("!!! should not happen !!!")
		}

		pickerOutletHeightConstraint = pickerOutlet?.heightAnchor.constraint(equalToConstant: settings.heightForPicker())
		pickerOutletHeightConstraint?.isActive = true

		submitButton.titleLabel?.font = settings.font()

		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

	func updateUI() {
		pickerOutlet?.frame.size.height = settings.heightForPicker()
		pickerOutletHeightConstraint?.constant = settings.heightForPicker()
	}

}
