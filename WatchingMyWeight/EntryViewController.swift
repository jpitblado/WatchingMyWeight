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

	@IBOutlet var weightTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!

	@IBAction func submitPressed(_ sender: UIButton) {
		let weight = Double(weightTextField.text ?? "0") ?? 0.0
		let date = datePicker.date
		if let indexPath = fromIndexPath {
			entries[indexPath.row].weight = Double(weight)
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

		if let indexPath = fromIndexPath {
			weightTextField.text = String(entries[indexPath.row].weight)
			datePicker.date = entries[indexPath.row].date
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}

}
