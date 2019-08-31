//
//  Extensions.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/16/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

	func updateNavBar() {
		// nav bar title setup
		let att = [NSAttributedString.Key.font: settings.font()]
		navigationController?.navigationBar.titleTextAttributes = att
	}

	func updateTabBarItems() {
		if let nav = self.parent as? UINavigationController {
			if let tbc = nav.parent as? UITabBarController {
				tbc.updateBarItems()
			}
		}
	}

	func askToLoad(fromStorage dataStorage: DataStorage) {
		var message: String

		switch dataStorage {
		case .Local:
			message = "this device"
		case .iCloud:
			message = "iCloud"
		case .HealthApp:
			message = "Health App"
		}
		let alert = UIAlertController(
			title: "Changing Data Storage",
			message: "Load data from \(message)?",
			preferredStyle: UIAlertController.Style.alert)
		let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
		let yesAction = UIAlertAction(
			title: "Yes",
			style: .default) { [unowned self, dataStorage] _ in
				switch dataStorage {
				case .Local:
					localReadWeights()
				case .iCloud:
					iCloudReadWeights()
				case .HealthApp:
					// nothing to do for this case
					break
				}
				self.updateTabBarItems()
		}
		alert.addAction(noAction)
		alert.addAction(yesAction)
		self.present(alert, animated: true, completion: nil)
	}

}

extension UITabBarController {

	func updateBarItems() {
		// tab bar item title setup
		let att = [NSAttributedString.Key.font: settings.font()]
		if let items = tabBar.items {
			for item in items {
				item.setTitleTextAttributes(att, for: .normal)
				if let title = item.title {
					if title.starts(with: "Weights") {
						if weights.count > 0 {
							item.title = "Weights (\(weights.count))"
						}
						else {
							item.title = "Weights"
						}
					}
					else if title.starts(with: "Steps") {
						if steps.count > 0 {
							item.title = "Steps (\(steps.count))"
						}
						else {
							item.title = "Steps"
						}
					}
				}
			}
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		updateBarItems()
	}

}

extension UITableViewController {

	open override func viewDidLoad() {
		super.viewDidLoad()

		updateNavBar()

		// prevent filling with empty rows
		tableView.tableFooterView = UIView()
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		updateNavBar()
	}

}
