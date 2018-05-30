//
//  DataStorageTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/20/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class DataStorageTableViewController: UITableViewController {

	// MARK: private data and methods

	var data = [DataStorage]()

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

		data.append(DataStorage.Local)
		data.append(DataStorage.iCloud)
		data.append(DataStorage.HealthApp)
		selectedRow = data.index(of: settings.dataStorage)

		navigationItem.title = "Data Storage"
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "Data Storage Cell", for: indexPath)

		switch data[indexPath.row] {
		case .Local:
			cell.textLabel?.text = "This device"
		case .iCloud:
			cell.textLabel?.text = "Use iCloud"
		case .HealthApp:
			cell.textLabel?.text = "Use Health App"
		}
		cell.textLabel?.font = settings.font()

		cell.accessoryType = UITableViewCellAccessoryType.none
		if selectedRow == indexPath.row {
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
		}

		return cell
	}

	// MARK: selections

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if selectedRow != indexPath.row {
			settings.dataStorage = data[indexPath.row]
			writeSettings()
			selectedRow = indexPath.row
			askToLoad(fromStorage: settings.dataStorage)
		}
	}

}
