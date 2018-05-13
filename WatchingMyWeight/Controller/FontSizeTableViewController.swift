//
//  FontSizeTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/12/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class FontSizeTableViewController: UITableViewController {

	// MARK: - Table view private data and methods

	private let min: CGFloat = 20.0
	private let max: CGFloat = 48.0
	private let step: CGFloat = 2.0

	private var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	private func updateUI() {
		tableView.reloadData()
	}

	private func value(fromRow row: Int) -> CGFloat {
		return min + CGFloat(row)*step
	}

	// MARK: - Table view loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		var size = settings.fontSize
		if (size < min) {
			size = min
		}
		else if (size > max) {
			size = max
		}
		selectedRow = Int((size - min)/step)

		navigationItem.title = "Font Size"
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let row = selectedRow {
			tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: false)
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = Int((Defaults.fontSizeMax - Defaults.fontSizeMin)/Defaults.fontSizeStep) + 1
		return rows
	}

	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return settings.heightForLabel(withFontSize: value(fromRow: indexPath.row))
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

	// MARK: - Table view actions

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		settings.fontSize = value(fromRow: indexPath.row)
		writeSettings()
		selectedRow = indexPath.row
	}

}
