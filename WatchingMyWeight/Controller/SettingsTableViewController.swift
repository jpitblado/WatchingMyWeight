//
//  SettingsTableViewController.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/7/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import UIKit

struct SettingCellInfo {

	var id: String
	var title: String
	var detail: ((Settings) -> String)?
	var isHeader: Bool
	var useSystemFont: Bool

	// detail cell
	init(id: String, title: String, detail: ((Settings) -> String)?) {
		self.id = id
		self.title = title
		self.detail = detail
		self.isHeader = false
		self.useSystemFont = false
	}

	// basic cell
	init(id: String, title: String, isHeader: Bool, usingSystemFont: Bool) {
		self.id = id
		self.title = title
		self.detail = nil
		self.isHeader = isHeader
		self.useSystemFont = usingSystemFont
	}

}

func getFontName(_ settings: Settings) -> String {
	if settings.fontName == "" {
		return "System"
	}
	return settings.fontName
}

func getDefaultWeight(_ settings: Settings) -> String {
	return String(format: "%.1f \(settings.units)", settings.weightDefault)
}

func getNewWeight(_ settings: Settings) -> String {
	switch settings.newWeight {
	case .Default:
		return "Default"
	case .MostRecent:
		return "Most Recent"
	case .Random:
		return "Random"
	}
}

func getUnits(_ settings: Settings) -> String {
	return "\(settings.units)"
}

func getStorage(_ settings: Settings) -> String {
	switch settings.dataStorage {
	case .Local:
		return "This device"
	case .iCloud:
		return "Use iCloud"
	case .HealthApp:
		return "Use Health App"
	}
}

class SettingsTableViewController: UITableViewController {

	// MARK: private data and methods

	private var data : [SettingCellInfo] = []

	private func updateUI() {
		tableView.reloadData()
	}

	// MARK: loading and appearing

	override func viewDidLoad() {
		super.viewDidLoad()

		var info : SettingCellInfo

		// Weight Properties
		info = SettingCellInfo(id: "Header Cell",
							   title: "Weight Properties",
							   isHeader: true,
							   usingSystemFont: false)
		data.append(info)
		info = SettingCellInfo(id: "Default Weight Setting Cell",
							   title: "Default",
							   detail: getDefaultWeight)
		data.append(info)
		info = SettingCellInfo(id: "New Weight Setting Cell",
							   title: "New",
							   detail: getNewWeight)
		data.append(info)
		info = SettingCellInfo(id: "Weight Units Setting Cell",
							   title: "Units",
							   detail: getUnits)
		data.append(info)

		// Data Storage
		info = SettingCellInfo(id: "Header Cell",
							   title: "Data",
							   isHeader: true,
							   usingSystemFont: false)
		data.append(info)
		info = SettingCellInfo(id: "Data Storage Setting Cell",
							   title: "Storage",
							   detail: getStorage)
		data.append(info)

		// Font Appearance
		info = SettingCellInfo(id: "Header Cell",
							   title: "Appearance",
							   isHeader: true,
							   usingSystemFont: false)
		data.append(info)
		info = SettingCellInfo(id: "Font Name Setting Cell",
							   title: "Font Name",
							   detail: getFontName)
		data.append(info)

		// Settings
		info = SettingCellInfo(id: "Header Cell",
							   title: "Settings",
							   isHeader: true,
							   usingSystemFont: true)
		data.append(info)
		info = SettingCellInfo(id: "Basic Cell",
							   title: "Reset",
							   isHeader: false,
							   usingSystemFont: true)
		data.append(info)

		// navigation bar settings
		navigationItem.title = "Settings"
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
		return data.count
	}

	// MARK: delegate

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var style: UIFont.TextStyle
		if data[indexPath.row].isHeader {
			style = .title1
		}
		else {
			style = .body
		}
		let font = settings.font(forTextStyle: style)
		return font.lineHeight*2.0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = indexPath.row
		let cell = tableView.dequeueReusableCell(withIdentifier: data[row].id, for: indexPath)

		var style: UIFont.TextStyle
		if data[row].isHeader {
			style = .title1
		}
		else {
			style = .body
		}

		var font: UIFont
		if  data[row].useSystemFont {
			font = settings.preferredFont(forTextStyle: style)
		}
		else {
			font = settings.font(forTextStyle: style)
		}

		if data[row].isHeader {
			if let headerCell = cell as? HeaderTableViewCell {
				headerCell.headerLabel.font = font
				headerCell.headerLabel.text = data[row].title
			}
			else {
				cell.textLabel?.font = font
				cell.textLabel?.text = data[row].title
			}
		}
		else {
			cell.textLabel?.font = font
			cell.textLabel?.text = data[row].title
			cell.detailTextLabel?.font = font
			cell.detailTextLabel?.text = ""
			if let getDetail = data[row].detail {
				cell.detailTextLabel?.text = getDetail(settings)
			}

		}

		return cell
	}

	// MARK: selections

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if data[indexPath.row].title == "Reset" && data[indexPath.row].detail == nil {
			let store = settings.dataStorage
			settings = Settings()
			writeSettings()
			if store != settings.dataStorage {
				askToLoad(fromStorage: settings.dataStorage)
			}
			updateUI()
			updateNavBar()
			updateTabBarItems()
		}
	}

	// MARK: navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let backItem = UIBarButtonItem()
		backItem.title = "Back"
		navigationItem.backBarButtonItem = backItem
	}

}
