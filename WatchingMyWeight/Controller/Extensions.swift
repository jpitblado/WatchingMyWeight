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

	override open func viewDidLoad() {
		super.viewDidLoad()

		// tab bar item setup
		let att = [NSAttributedStringKey.font: settings.font(ofSize: Defaults.uiFontSize)]
		UITabBarItem.appearance().setTitleTextAttributes(att, for: .normal)
	}

}

extension UITableViewController {

	override open func viewDidLoad() {
		super.viewDidLoad()

		// navigation bar setup
		let att = [NSAttributedStringKey.font : settings.font(ofSize: Defaults.uiFontSize)]
		navigationController?.navigationBar.titleTextAttributes = att

		// prevent filling with empty rows
		tableView.tableFooterView = UIView()
	}

}
