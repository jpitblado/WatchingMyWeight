//
//  SettingsTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/7/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	// MARK: loading and appearing

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

	// MARK: data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return settings.heightForLabel()
	}

	// MARK: delegate

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell

		switch indexPath.row {
		case 0:		// font size
			cell = tableView.dequeueReusableCell(withIdentifier: "Font Size Setting Cell", for: indexPath)
			cell.textLabel?.text = "Font Size"
			cell.detailTextLabel?.text = "\(settings.fontSize)"
		case 1:		// weight default
			cell = tableView.dequeueReusableCell(withIdentifier: "Default Weight Setting Cell", for: indexPath)
			cell.textLabel?.text = "Default Weight"
			cell.detailTextLabel?.text = String(format: "%.1f \(settings.weightScale)", settings.weightDefault)
		case 2:		// new weight
			cell = tableView.dequeueReusableCell(withIdentifier: "New Weight Setting Cell", for: indexPath)
			cell.textLabel?.text = "New Weight"
			switch settings.newWeight {
			case .Default:
				cell.detailTextLabel?.text = "Default"
			case .MostRecent:
				cell.detailTextLabel?.text = "Most Recent"
			}
		default:	// scale
			cell = tableView.dequeueReusableCell(withIdentifier: "Weight Scale Setting Cell", for: indexPath)
			cell.textLabel?.text = "Weight Scale"
			cell.detailTextLabel?.text = "\(settings.weightScale)"
/*
			switch settings.weightScale {
			case .kg:
				cell.detailTextLabel?.text = "Kilograms"
			case .lbs:
				cell.detailTextLabel?.text = "Pounds"
			}
*/
		}

		cell.textLabel?.font = settings.font()
		cell.detailTextLabel?.font = settings.font()

		return cell
	}

	// MARK: navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem
	}

}
