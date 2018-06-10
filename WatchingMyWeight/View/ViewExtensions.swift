//
//  Extensions.swift
//  WatchingMyWeight
//
//  Created by Jeffrey Pitblado on 6/9/18.
//  Copyright © 2018 Jeffrey Pitblado. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	func createLabel() -> UILabel {
		let label = UILabel()
		addSubview(label)
		return label
	}

	func configureLabel(_ label: UILabel, withText text: String) {
		label.text = text
		label.frame.size = CGSize.zero
		label.sizeToFit()
	}
}

extension CGRect {
	func zoom(by scale: CGFloat) -> CGRect {
		let newWidth = width * scale
		let newHeight = height * scale
		return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
	}
}

extension CGPoint {
	func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
		return CGPoint(x: x+dx, y: y+dy)
	}
}
