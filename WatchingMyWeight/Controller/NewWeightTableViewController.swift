//
//  NewWeightTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/12/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class NewWeightTableViewController: UITableViewController {

	// MARK: private data and methods

	private var data = [NewWeight]()

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

		data.append(NewWeight.Default)
		data.append(NewWeight.MostRecent)
		data.append(NewWeight.Random)
		selectedRow = data.index(of: settings.newWeight)

		navigationItem.title = "New Weight"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "New Weight Cell", for: indexPath)

		cell.textLabel?.text = data[indexPath.row].rawValue
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
		if selectedRow != indexPath.row {
			settings.newWeight = data[indexPath.row]
			writeSettings()
			selectedRow = indexPath.row
		}
	}

}
