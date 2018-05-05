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

		readEntries()
	}

	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return entries.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let entry = entries[indexPath.row]

		let calendar = Calendar.current
		let month = calendar.component(.month, from: entry.date)
		let day = calendar.component(.day, from: entry.date)
		let year = calendar.component(.year, from: entry.date)
		let hour = calendar.component(.hour, from: entry.date)
		let minute = calendar.component(.minute, from: entry.date)
		let second = calendar.component(.second, from: entry.date)

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = "\(entry.weight)"
		cell.detailTextLabel?.text = "\(year)-\(month)-\(day) \(hour):\(minute) \(second)"

		return cell
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
