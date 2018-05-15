//
//  WeigthTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class WeightTableViewController: UITableViewController, UINavigationControllerDelegate {

	// MARK: private methods

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		// navigation bar settings
		/*
		let att = [NSAttributedStringKey.font: settings.font()
		self.navigationController?.navigationBar.titleTextAttributes = att
		*/
		navigationItem.title = "Weight Data"

		// prevent filling with empty rows
		tableView.tableFooterView = UIView()

		// settings setup
		readSettings()

		// data setup
		readWeights()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		sortWeights()

		tableView.reloadData()
	}

	// MARK: data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weights.count
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return settings.heightForLabel()
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
