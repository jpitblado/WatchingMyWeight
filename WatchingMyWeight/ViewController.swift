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
		let att = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: settings.fontSize)]
		self.navigationController?.navigationBar.titleTextAttributes = att
		*/
		navigationItem.title = "Weight Data"

		// data setup
		readEntries()

		// table settings
		tableView.rowHeight = settings.fontSize * (1.0 + 2*Defaults.spacing)
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

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let entry = entries[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// Weight label
		cell.textLabel?.text = "\(entry.weight)"
		cell.textLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)

		// Date label
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.none
		cell.detailTextLabel?.text = dateFormatter.string(from: entry.date)
		cell.detailTextLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)

		return cell
	}

	// MARK: Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let backItem = UIBarButtonItem()
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
