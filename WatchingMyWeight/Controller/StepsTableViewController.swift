//
//  StepsTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/25/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit
import HealthKit

class StepsTableViewController: UITableViewController {

	// MARK: private properties and methods

	private lazy var refresher: UIRefreshControl = {
		let refresherControl = UIRefreshControl()
		refresherControl.tintColor = .black
		refresherControl.addTarget(self, action: #selector(getData), for: .valueChanged)
		return refresherControl
	}()

	private func updateUI() {
		tableView.reloadData()
		if HealthData.available {
			navigationItem.title = "Step Data (\(steps.count))"
		}
		else {
			navigationItem.title = "Step Data Not Available"
		}
		self.updateTabBarItems()
		if self.refresher.isRefreshing {
			let deadline = DispatchTime.now() + .milliseconds(500)
			DispatchQueue.main.asyncAfter(deadline: deadline) {
				self.refresher.endRefreshing()
			}
		}
	}

	// MARK: public methods

	@objc
	func getData() {
		HealthData.getSteps(fromLastDays: 21) {
			DispatchQueue.main.async {
				self.updateUI()
			}
		}
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.refreshControl = refresher

		// dataSetup
		getData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateUI()
	}

	// MARK: data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return steps.count
	}

	// MARK: delegate

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Step Cell", for: indexPath)
		let entry = steps[indexPath.row]

		// Weight label
		cell.detailTextLabel?.text = "\(entry.count)"
		cell.detailTextLabel?.font = settings.font()
		cell.detailTextLabel?.adjustsFontSizeToFitWidth = true

		// Date label
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeStyle = DateFormatter.Style.none
		cell.textLabel?.text = dateFormatter.string(from: entry.date)
		cell.textLabel?.font = settings.font()
		cell.textLabel?.adjustsFontSizeToFitWidth = true

		return cell
	}

	// MARK: navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem
	}
}
