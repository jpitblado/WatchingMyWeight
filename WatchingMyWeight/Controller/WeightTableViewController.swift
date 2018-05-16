//
//  WeigthTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class WeightTableViewController: UITableViewController, UINavigationControllerDelegate {

	// MARK: outlets

	@IBOutlet var addButtonItem: UIBarButtonItem!

	// MARK: private methods

	private func updateUI() {
		navigationItem.title = "Weight Data (\(weights.count) entries)"
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		// data setup
		readWeights()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		sortWeights()

		tableView.reloadData()

		updateUI()
	}

	// MARK: data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weights.count
	}

	// MARK: delegate

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let entry = weights[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// Weight label
		cell.detailTextLabel?.text = String(format: "%.1f \(settings.units)", settings.weightValue(forWeight: entry.weight, inUnits: entry.units))
		cell.detailTextLabel?.font = settings.font()

		// Date label
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.none
		cell.textLabel?.text = dateFormatter.string(from: entry.date)
		cell.textLabel?.font = settings.font()

		return cell
	}

	// MARK: editing cells

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		if editing == true {
			addButtonItem.isEnabled = false
		}
		else {
			addButtonItem.isEnabled = true
		}
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			weights.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			writeWeights()
			updateUI()
		}
	}

	// MARK: Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem

		if segue.identifier == "Edit Weight" {
			if let dest = segue.destination as? WeightViewController {
				if let selectedCell = sender as? UITableViewCell {
					if let indexPath = tableView.indexPath(for: selectedCell) {
						dest.fromIndexPath = indexPath
					}
				}
			}
		}
	}

}
