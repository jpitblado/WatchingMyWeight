//
//  SettingDetailViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/8/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController {

	@IBOutlet var settingDescriptionLabel: UILabel!
	@IBOutlet var pickerOutlet: UIPickerView!
	@IBOutlet var submitButton: UIButton!

	@IBAction func submitPressed(_ sender: UIButton) {
		switch settingType {
		case .fontSize:
			settings.fontSize = fontSizePicker?.value ?? Defaults.fontSize
		case .weightDefault:
			settings.weightDefault = weightPicker?.value ?? Defaults.weight
		case .newWeight:
			settings.newWeight = newWeightPicker?.value ?? NewWeight.top
		case .scale:
			print("!! no submit logic for scale")
		}
		writeSettings()
		navigationController?.popViewController(animated: true)
	}

	var weightPicker: WeightPickerView?
	var fontSizePicker: FontSizePickerView?
	var newWeightPicker: NewWeightPickerView?

	var settingName: String = ""
	var settingType: SettingType = SettingType.fontSize

	override func viewDidLoad() {
		super.viewDidLoad()

		settingDescriptionLabel.font = UIFont.systemFont(ofSize: settings.fontSize)

		navigationItem.title = settingName
		switch settingType {
		case .fontSize:
			fontSizePicker = FontSizePickerView()
			pickerOutlet.dataSource = fontSizePicker
			pickerOutlet.delegate = fontSizePicker
			fontSizePicker?.set(fromFontSize: settings.fontSize)
			fontSizePicker?.update(pickerOutlet)
			settingDescriptionLabel.text = "Change the \(settingName)"
		case .weightDefault:
			weightPicker = WeightPickerView()
			pickerOutlet.dataSource = weightPicker
			pickerOutlet.delegate = weightPicker
			weightPicker?.set(fromWeight: settings.weightDefault)
			weightPicker?.update(pickerOutlet)
			settingDescriptionLabel.text = "Change the \(settingName)"
		case .newWeight:
			newWeightPicker = NewWeightPickerView()
			pickerOutlet.dataSource = newWeightPicker
			pickerOutlet.delegate = newWeightPicker
			newWeightPicker?.set(fromNewWeight: settings.newWeight)
			newWeightPicker?.update(pickerOutlet)
			settingDescriptionLabel.text = "\(settingName) From"
		case .scale:
			settingDescriptionLabel.text = "!! not implemented yet !!"
		}

		submitButton.titleLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)
	}

}
