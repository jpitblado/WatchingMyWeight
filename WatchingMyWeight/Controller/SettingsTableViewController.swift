//
//  SettingsTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/7/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// navigation bar settings
		navigationItem.title = "Settings"
	}

	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return settings.heightForLabel()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell", for: indexPath)
		cell.textLabel?.font = settings.font()
		cell.detailTextLabel?.font = settings.font()

		switch indexPath.row {
		case 0:		// font size
			cell.textLabel?.text = "Font Size"
			cell.detailTextLabel?.text = "\(settings.fontSize)"
		case 1:		// weight default
			cell.textLabel?.text = "Default Weight"
			cell.detailTextLabel?.text = String(format: "%.1f", settings.weightDefault)
		case 2:		// new weight
			cell.textLabel?.text = "New Weight"
			switch settings.newWeight {
			case .fixed:
				cell.detailTextLabel?.text = "Default"
			case .top:
				cell.detailTextLabel?.text = "Top"
			}
		default:	// scale
			cell.textLabel?.text = "Weight Scale"
			cell.detailTextLabel?.text = "\(settings.weightScale.rawValue)"
		}

		return cell
	}

	// MARK: Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "Setting Detail" {
			let backItem = UIBarButtonItem()
			backItem.title = "Discard"
			navigationItem.backBarButtonItem = backItem
			if let dest = segue.destination as? SettingDetailViewController {
				if let selectedCell = sender as? UITableViewCell {
					dest.settingName = selectedCell.textLabel?.text ?? ""
					if let indexPath = tableView.indexPath(for: selectedCell) {
						switch indexPath.row {
						case 0:		dest.settingType = .fontSize
						case 1:		dest.settingType = .weightDefault
						case 2:		dest.settingType = .newWeight
						default:	dest.settingType = .weightScale
						}
					}
				}
			}
		}
	}

}
