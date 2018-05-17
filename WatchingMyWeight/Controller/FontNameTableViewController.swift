//
//  FontNameTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/16/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

class FontNameTableViewController: UITableViewController {

	// MARK: private properties and methods

	private var data = [String]()

	private var selectedRow: Int? {
		didSet {
			updateUI()
		}
	}

	private func updateUI() {
		tableView.reloadData()

		updateNavBar()
		updateTabBarItems()

/*		if let nav = self.parent as? UINavigationController {
			if let tbc = nav.parent as? UITabBarController {
				tbc.updateBarItem()
			}
		}
*/
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
        super.viewDidLoad()

		let families = UIFont.familyNames.sorted(by: <)

		data.append("")						// system font
		for family in families {
			let names = UIFont.fontNames(forFamilyName: family).sorted(by: <)
			for name in names {
				data.append(name)
			}
		}
		selectedRow = data.index(of: settings.fontName) ?? 0

		navigationItem.title = "Font Name"
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let row = selectedRow {
			tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: false)
		}
	}

    // MARK: data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

	// MARK: delegate

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Font Name Cell", for: indexPath)

		let name = data[indexPath.row]
		if name == "" {
			cell.textLabel?.text = "System"
			cell.textLabel?.font = UIFont.systemFont(ofSize: settings.fontSize)
		}
		else {
			cell.textLabel?.text = name
			cell.textLabel?.font = UIFont(name: name, size: settings.fontSize)
		}

		cell.detailTextLabel?.text = ""
		cell.detailTextLabel?.font = settings.font()
		if selectedRow == indexPath.row {
			cell.detailTextLabel?.text = "✓"
			cell.detailTextLabel?.textColor = UIColor.blue
		}

        return cell
    }

	// MARK: selections

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		settings.fontName = data[indexPath.row]
		writeSettings()
		selectedRow = indexPath.row
	}

}
