//
//  HealthData.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/26/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import HealthKit

struct TimeConstants {

	static let secondsPerDay: Double = 60*60*24

}

struct HealthData {

	static let available = HKHealthStore.isHealthDataAvailable()

	static let stepsCountQT = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
	static let bodyMassQT = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!

	static func getSteps(fromLastDays days: Double, completion: @escaping () -> Void) {
		if !available {
			return
		}

		let healthStore = HKHealthStore()

		healthStore.requestAuthorization(toShare: [], read: Set([stepsCountQT])) {
			(success, error) in
			if !success {
				NSLog("HealthKit failed to give authorization for steps!")
			}
		}

		// end date is today
		let endDate = Date()

		// start date is 'days' prior to end date
		var startDate = Date(timeInterval: -days*TimeConstants.secondsPerDay, since: endDate)
		startDate = Calendar.current.startOfDay(for: startDate)

		// set predicate and interval
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		var interval = DateComponents()
		interval.day = 1

		let options : HKStatisticsOptions = [HKStatisticsOptions.cumulativeSum]
		// query
		let query = HKStatisticsCollectionQuery(quantityType: stepsCountQT,
												quantitySamplePredicate: predicate,
												options: options,
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

			if let myresults = results {
				steps.removeAll()

				myresults.enumerateStatistics(from: startDate, to: endDate) {
					(statistics, stop) in

					if let quantity = statistics.sumQuantity() {
						let count = Int(quantity.doubleValue(for: HKUnit.count()))
						let date = statistics.startDate
						let step = Step(count: count, date: date)
						steps.append(step)
					}
				}
			}

			sortSteps()
			completion()
		}

		healthStore.execute(query)
	}

	static func getWeights(fromLastDays days: Double, completion: @escaping () -> Void) {
		if !available {
			return
		}

		let healthStore = HKHealthStore()

		healthStore.requestAuthorization(toShare: [], read: Set([bodyMassQT])) {
			(success, error) in
			if !success {
				NSLog("HealthKit failed to give authorization for body mass!")
			}
		}

		// end date is today
		let endDate = Date()

		// start date is 'days' prior to end date
		var startDate = Date(timeInterval: -days*TimeConstants.secondsPerDay, since: endDate)
		startDate = Calendar.current.startOfDay(for: startDate)

		// set predicate and interval
//		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
		let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
		var interval = DateComponents()
		interval.minute = 1

		let options : HKStatisticsOptions = [HKStatisticsOptions.discreteAverage,
											 .discreteMin,
											 .discreteMax,
											 .separateBySource]
		// query
		let query = HKStatisticsCollectionQuery(quantityType: bodyMassQT,
												quantitySamplePredicate: predicate,
												options: options,
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

			if let myresults = results {
				weights.removeAll()

				myresults.enumerateStatistics(from: startDate, to: endDate) {
					(statistics, stop) in

					if let quantity = statistics.minimumQuantity() {
						let mass = quantity.doubleValue(for: HKUnit.pound())
						let date = statistics.startDate
						let weight = Weight(weight: mass, units: .lbs, date: date)
						weights.append(weight)
					}
				}
			}

			sortWeights()
			completion()
		}

		healthStore.execute(query)
	}

}
