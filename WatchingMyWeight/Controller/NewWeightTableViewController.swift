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

	private var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	private func updateUI() {
		tableView.reloadData()
	}

	private func value(fromRow row: Int) -> NewWeight {
		if row == 0 {
			return NewWeight.Default
		}
		if row == 1 {
			return NewWeight.MostRecent
		}
		return NewWeight.Random
	}

	// MARK: loading

    override func viewDidLoad() {
        super.viewDidLoad()

		switch settings.newWeight {
		case .Default:
			selectedRow = 0
		case .MostRecent:
			selectedRow = 1
		case .Random:
			selectedRow = 2
		}
		navigationItem.title = "New Weight"
    }

    // MARK: data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

	// MARK: delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "New Weight Cell", for: indexPath)

		if indexPath.row == 0 {
			cell.textLabel?.text = "Use Default Weight"
		}
		else if indexPath.row == 1 {
			cell.textLabel?.text = "Use Most Recent Weight"
		}
		else if indexPath.row == 2 {
			cell.textLabel?.text = "Use Random Weight"
		}
		cell.textLabel?.font = settings.font()

		cell.detailTextLabel?.text = ""
		cell.detailTextLabel?.font = settings.font()
		if selectedRow == indexPath.row {
			cell.detailTextLabel?.text = "✓"
			cell.detailTextLabel?.textColor = UIColor.blue
		}

        return cell
    }

	// MARK: selections

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		settings.newWeight = value(fromRow: indexPath.row)
		writeSettings()
		selectedRow = indexPath.row
	}

}
