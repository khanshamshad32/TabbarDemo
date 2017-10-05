//
//  ViewController.swift
//  TabBarViewDemo
//
//  Created by Shamshad Khan on 28/07/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var mTabView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)		
		
		let tabView = TabbarView()
		tabView.addOver(superView: self.mTabView)
		
		let tab1 = Tab1()
		tab1.backgroundColor = UIColor.green
		try? tabView.add(tab: tab1)

		let tab2 = Tab2()
		tab2.backgroundColor = UIColor.gray
		try? tabView.add(tab: tab2)

		let tab3 = Tab3()
		tab3.backgroundColor = UIColor.yellow
		try? tabView.add(tab: tab3)

		let tab4 = Tab4()
		tab4.backgroundColor = UIColor.orange
		try? tabView.add(tab: tab4)
	}
}

