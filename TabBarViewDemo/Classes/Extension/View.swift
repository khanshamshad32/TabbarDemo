//
//  View.swift
//  CEConnect
//
//  Created by Shamshad Khan on 08/08/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
	
	func addShadow() {
	
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 2
		layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
	}
	
	func makeCircular() {
	
		layer.cornerRadius = frame.size.height/2
		layer.masksToBounds = true
	}
}
