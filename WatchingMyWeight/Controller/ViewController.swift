//
//  ViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		// navigation bar settings
		/*
		let att = [NSAttributedStringKey.font: settings.font()
		self.navigationController?.navigationBar.titleTextAttributes = att
		*/
		navigationItem.title = "Weight Data"

		// settings setup
		readSettings()

		// data setup
		readEntries()
	}

	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: Table view

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return settings.heightForLabel()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let entry = entries[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// Date label
		cell.detailTextLabel?.text = String(format: "%.1f", entry.weight)
		cell.detailTextLabel?.font = settings.font()

		// Weight label
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

		if segue.identifier == "Settings" {
			backItem.title = "Back"
			navigationItem.backBarButtonItem = backItem
			return
		}

		backItem.title = "Discard"
		navigationItem.backBarButtonItem = backItem

		if segue.identifier == "Edit Entry" {
			if let dest = segue.destination as? EntryViewController {
				if let selectedCell = sender as? UITableViewCell {
					if let indexPath = tableView.indexPath(for: selectedCell) {
						dest.fromIndexPath = indexPath
					}
				}
			}
		}
	}

}
