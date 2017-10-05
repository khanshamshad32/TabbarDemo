//
//  Tab2.swift
//  TabBarViewDemo
//
//  Created by Shamshad Khan on 04/10/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import UIKit

class Tab2: UIView, TabbarViewDelegate {
	
	//	MARK: - Tabbar Delegate
	
	var title:String { return "Tab2"}
	var icon: UIImage? {return UIImage(named: "ic_airline_seat_recline_normal_white_24dp.png") }
	
	func viewSelected(_ tabView: TabbarView) {
	}
	
	func viewDidDisappear(_ tabview: TabbarView) {
	}
	
	func reloadTab(_ tabview: TabbarView) {
	}
}
