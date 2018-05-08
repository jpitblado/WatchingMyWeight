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

		navigationItem.title = "Settings"
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell", for: indexPath)
		cell.textLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)
		cell.detailTextLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)

		switch indexPath.row {
		case 0:		// font size
			cell.textLabel?.text = "Font size"
			cell.detailTextLabel?.text = "\(settings.fontSize)"
		case 1:		// weight default
			cell.textLabel?.text = "Default weight"
			cell.detailTextLabel?.text = "\(settings.weightDefault)"
		case 2:		// new weight
			cell.textLabel?.text = "New weight from"
			switch settings.newWeight {
			case .fixed:
				cell.detailTextLabel?.text = "default"
			case .top:
				cell.detailTextLabel?.text = "top"
			}
		default:	// scale
			cell.textLabel?.text = "Weight scale"
			cell.detailTextLabel?.text = "\(settings.scale.rawValue)"
		}

		return cell
	}

}
