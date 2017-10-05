//
//  Tab4.swift
//  TabBarViewDemo
//
//  Created by Shamshad Khan on 04/10/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import UIKit

class Tab4: UIView, TabbarViewDelegate {

	//	MARK: - Tabbar Delegate
	
	var title:String { return "Tab1"}
	var icon: UIImage? {return UIImage(named: "ic_do_not_disturb_white_48dp.png") }
	
	func viewSelected(_ tabView: TabbarView) {
	}
	
	func viewDidDisappear(_ tabview: TabbarView) {
	}
	
	func reloadTab(_ tabview: TabbarView) {
	}
}
