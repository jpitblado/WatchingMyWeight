//
//  UnitsTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/13/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class UnitsTableViewController: UITableViewController {

	// MARK: private data and methods

	private var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	private func updateUI() {
		tableView.reloadData()
	}

	private func value(fromRow row: Int) -> Units {
		if row == 0 {
			return Units.kg
		}
		return Units.lbs
	}

	// MARK: loading

	override func viewDidLoad() {
		super.viewDidLoad()

		switch settings.units {
		case .kg:
			selectedRow = 0
		case .lbs:
			selectedRow = 1
		}
		navigationItem.title = "Weight Units"
	}

	// MARK: data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	// MARK: delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Weight Units Cell", for: indexPath)

		if indexPath.row == 0 {
			cell.textLabel?.text = "Kilograms (\(Units.kg))"
		}
		else {
			cell.textLabel?.text = "Pounds (\(Units.lbs))"
		}
		cell.textLabel?.font = settings.font()

		cell.detailTextLabel?.text = ""
		cell.detailTextLabel?.font = Defaults.uiFont()
		if selectedRow == indexPath.row {
			cell.detailTextLabel?.text = "✓"
			cell.detailTextLabel?.textColor = UIColor.blue
		}

        return cell
    }

	// MARK: selections

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		settings.units = value(fromRow: indexPath.row)
		writeSettings()
		selectedRow = indexPath.row
	}

}
