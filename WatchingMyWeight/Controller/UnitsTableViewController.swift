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

	var data = [Units]()

	private var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	private func updateUI() {
		tableView.reloadData()
	}

	// MARK: loading

	override func viewDidLoad() {
		super.viewDidLoad()

		data.append(Units.kg)
		data.append(Units.lbs)

		selectedRow = data.index(of: settings.units)

		navigationItem.title = "Weight Units"
	}

	// MARK: data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	// MARK: delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Weight Units Cell", for: indexPath)

		switch data[indexPath.row] {
		case .kg:
			cell.textLabel?.text = "Kilograms (\(Units.kg))"
		case .lbs:
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
		settings.units = data[indexPath.row]
		writeSettings()
		selectedRow = indexPath.row
	}

}
