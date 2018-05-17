//
//  Extensions.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/16/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {

	func updateBarItems() {
		// tab bar item title setup
		let att = [NSAttributedStringKey.font: settings.uiFont()]
		if let items = tabBar.items {
			for item in items {
				item.setTitleTextAttributes(att, for: .normal)
			}
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		updateBarItems()
	}

}

extension UITableViewController {

	func updateNavBar() {
		// nav bar title setup
		let att = [NSAttributedStringKey.font: settings.uiFont()]
		navigationController?.navigationBar.titleTextAttributes = att
	}

	func updateTabBarItems() {
		if let nav = self.parent as? UINavigationController {
			if let tbc = nav.parent as? UITabBarController {
				tbc.updateBarItems()
			}
		}
	}

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
