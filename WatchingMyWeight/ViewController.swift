//
//  ViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/3/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationControllerDelegate {

	var entries = [Entry]()

	override func viewDidLoad() {
		super.viewDidLoad()

		// button to add an entry
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEntry))

		readEntries()
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

	@objc func addNewEntry() {
		let ac = UIAlertController(title: "Enter weight", message: nil, preferredStyle: .alert)
		ac.addTextField()

		let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
			let weight = ac.textFields![0]
			self.submit(weight: weight.text!)
		}

		ac.addAction(submitAction)
		present(ac, animated: true)
	}

	func submit(weight wgt: String) {
		// need to check for invalid weight string
		let weight = Double(wgt) ?? 0.0
		let newEntry = Entry(weight: weight)
		entries.insert(newEntry, at: 0)
		writeEntries()

		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}

	func readEntries() {
		let defaults = UserDefaults.standard

		if let savedEntries = defaults.object(forKey: "entries") as? Data {
			let jsonDecoder = JSONDecoder()

			do {
				entries = try jsonDecoder.decode([Entry].self, from: savedEntries)
			}
			catch {
				print("Failed to load entries!.")
			}
		}
	}

	func writeEntries() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(entries) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "entries")
		}
		else {
			print("Failed to save entries!")
		}
	}

}
