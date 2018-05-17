//
//  Device.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 5/16/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

struct Device {
	static let width			= Int(UIScreen.main.bounds.size.width)
	static let height			= Int(UIScreen.main.bounds.size.height)
	static let max_length		= max(width, height)
	static let min_length		= min(width, height)

	static let is_ipad			= UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
	static let is_iphone		= UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
	static let is_retina		= UIScreen.main.scale >= 2.0
	static let is_plus			= UIScreen.main.scale >= 3.0

	static let is_ipad_pro10p5	= is_ipad && max_length == 1112
	static let is_ipad_pro12p9	= is_ipad && max_length == 1366

	static let is_iphone_se		= is_iphone && max_length == 568
	static let is_iphone_6		= is_iphone && max_length == 667
	static let is_iphone_6p		= is_iphone && max_length == 667 && is_plus
	static let is_iphone_7p		= is_iphone && max_length == 736 && is_plus
	static let is_iphone_x		= is_iphone && max_length == 812

	static func report() {
		print("width           = \(Device.width)")
		print("height          = \(Device.height)")
		print("is_pad          = \(Device.is_ipad)")
		print("is_iphone       = \(Device.is_iphone)")
		print("is_retina       = \(Device.is_retina)")
		print("is_plus         = \(Device.is_plus)")
		print("is_ipad_pro10p5 = \(Device.is_ipad_pro10p5)")
		print("is_ipad_pro12p9 = \(Device.is_ipad_pro12p9)")
		print("is_iphone_se    = \(Device.is_iphone_se)")
		print("is_iphone_6     = \(Device.is_iphone_6)")
		print("is_iphone_6p    = \(Device.is_iphone_6p)")
		print("is_iphone_7p    = \(Device.is_iphone_7p)")
		print("is_iphone_x     = \(Device.is_iphone_x)")
	}
}
