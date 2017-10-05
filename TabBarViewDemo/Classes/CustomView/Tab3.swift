
//
//  Tab3.swift
//  TabBarViewDemo
//
//  Created by Shamshad Khan on 04/10/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import UIKit

class Tab3: UIView, TabbarViewDelegate {
	
	//	MARK: - Tabbar Delegate
	
	var title:String { return "Tab1"}
	var icon: UIImage? {return UIImage(named: "ic_burst_mode_white_24dp.png") }
	
	func viewSelected(_ tabView: TabbarView) {
	}
	
	func viewDidDisappear(_ tabview: TabbarView) {
	}
	
	func reloadTab(_ tabview: TabbarView) {
	}
}
