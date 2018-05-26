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

	private let available = HKHealthStore.isHealthDataAvailable()

	private let secondsPerDay: Double = 60*60*24

	private func updateUI() {
		if available {
			navigationItem.title = "Step Data (\(steps.count))"
		}
		else {
			navigationItem.title = "Step Data Not Available"
		}
		self.updateTabBarItems()
	}

	private func addStep(_ step : Step) {
		steps.append(step)
	}

	func zz() {
		if HKHealthStore.isHealthDataAvailable() {
			let healthStore = HKHealthStore()

			//			let sampleTypes = Set([HKSampleType.quantityType(forIdentifier: .stepCount)!])
			let objectTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])

			healthStore.requestAuthorization(toShare: [], read: objectTypes, completion: { (success, error) in
				if !success {
					NSLog("HealthKit failed to give authorization for steps!")
				}
			})
		}
		else {
			NSLog("HealthKit NOT available!!!")
		}


	}
	private func getSteps() {
		if !available {
			return
		}

		let healthStore = HKHealthStore()

		// quantity type
		let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

//		let sampleTypes = Set([HKSampleType.quantityType(forIdentifier: .stepCount)!])
//		let objectTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])

		healthStore.requestAuthorization(toShare: [], read: Set([stepsCount!])) {
			(success, error) in
			if !success {
				NSLog("HealthKit failed to give authorization for steps!")
			}
		}

		// end date is today
		let endDate = Date()

		// start date -- 3 weeks ago
		let start = Date(timeInterval: -21*secondsPerDay, since: endDate)
		let startDate = Calendar.current.startOfDay(for: start)

		// set predicate and interval
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		var interval = DateComponents()
		interval.day = 1

		// perform the query
		let query = HKStatisticsCollectionQuery(quantityType: stepsCount!,
												quantitySamplePredicate: predicate,
												options: [.cumulativeSum],
												anchorDate: startDate,
												intervalComponents: interval)
		query.initialResultsHandler = {
			(query, results, error) in

			if error != nil {
				NSLog("query resulted in error")
				if let message = error?.localizedDescription {
					NSLog("error message was \(message)")
				}
				return
			}

			DispatchQueue.main.async {
				if let myresults = results {
					steps.removeAll()

					myresults.enumerateStatistics(from: startDate, to: endDate) {
						(statistics, stop) in

						if let quantity = statistics.sumQuantity() {
							let count = Int(quantity.doubleValue(for: HKUnit.count()))
							let date = statistics.startDate
							let step = Step(count: count, date: date)
							self.addStep(step)
						}
					}
				}

				sortSteps()
				self.tableView.reloadData()
				self.updateUI()
			}
		}

		healthStore.execute(query)
	}

	// MARK: loading and appearing

		override func viewDidLoad() {
				super.viewDidLoad()

		getSteps()
		}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		tableView.reloadData()
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
}
