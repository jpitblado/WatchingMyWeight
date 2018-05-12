//
//  FontSizeTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/12/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class FontSizeTableViewController: UITableViewController {

	var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	func updateUI() {
		tableView.reloadData()
		tableView.scrollToRow(at: IndexPath(row: selectedRow!, section: 0), at: .middle, animated: false)
	}

	func value(fromRow row: Int) -> CGFloat {
		return Defaults.fontSizeMin + CGFloat(row)*Defaults.fontSizeStep
	}

	func height(forRow row: Int) -> CGFloat {
		return settings.heightForLabel(withFontSize: value(fromRow: row))
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		selectedRow = Int((settings.fontSize - Defaults.fontSizeMin)/Defaults.fontSizeStep)
		navigationItem.title = "Font Size"
	}

	override func viewDidAppear(_ animated: Bool) {
		updateUI()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = Int((Defaults.fontSizeMax - Defaults.fontSizeMin)/Defaults.fontSizeStep) + 1
		return rows
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Font Size Cell", for: indexPath)

		let size = value(fromRow: indexPath.row)
		cell.textLabel?.text = String(format: "%.1f", size)
		cell.textLabel?.font = settings.font(ofSize: size)

		cell.detailTextLabel?.text = ""
		cell.detailTextLabel?.font = settings.font(ofSize: size)
		if selectedRow == indexPath.row {
			cell.detailTextLabel?.text = "✓"
			cell.detailTextLabel?.textColor = UIColor.blue
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		settings.fontSize = value(fromRow: indexPath.row)
		writeSettings()
		selectedRow = indexPath.row
	}

}
