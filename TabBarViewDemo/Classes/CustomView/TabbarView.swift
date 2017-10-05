//
//  TabView.swift
//  CEConnect
//
//  Created by Shamshad Khan on 27/07/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

import UIKit

//	MARK: - ENUM
enum EDirection: String {

	case Left = "Left"
	case Right = "Right"
	case Vertical = "Vertical"
}

enum TabbarViewError : Error {
	case NotSubClassOfUIView
}

//	MARK: - Protocol
protocol TabbarViewDelegate {
	
	var title: String {get}
	var icon: UIImage? {get}
	
	func viewSelected(_ tabView:TabbarView)
	func viewDidDisappear(_ tabview: TabbarView)
	func reloadTab(_ tabview: TabbarView)
}

//	MARK: -
class TabbarView: UIView {

//	MARK: - Property
	private let kTitleIndex = 101
	private let kTitleHeight = CGFloat(40.0)
	private let kTitleBGColor = UIColor.blue
	private let kLineHeight = CGFloat(3)
	private let kEdgeInset = CGFloat(8)
	
	private var mPanGesture: UIPanGestureRecognizer!
	private var mPanCurrentPoint:CGPoint!
	private var mPanPreviousPoint:CGPoint!
	
	private var mActiveView: UIView?
	private var mPrevActiveView: UIView?
	private var mTabArray = Array<UIView>()
	private var mTitleLine: UIView!
	private var mTitleView: UIStackView!
	
	private var mLeadingConstraint: NSLayoutConstraint?
	private var mLineLConstraint: NSLayoutConstraint?
	
//	MARK: - Public
	
	func addOver(superView view:UIView) {
		
		view.addSubview(self)
		
		self.clipsToBounds = true
		addConstraint(view: self, relatedToView: view)
		addPenGesture()
		addTitleView()
	}
	
	func add(tab: TabbarViewDelegate) throws {
	
		if (tab as? UIView) == nil { throw TabbarViewError.NotSubClassOfUIView	}
		
		add(tab: tab as! UIView)
		addTitle(tabbar: tab)
		bringSubview(toFront: mTitleView)
		bringSubview(toFront: mTitleLine)
	}	
	
	func refreshTabs() {
	
		for tab in mTabArray {
			(tab as! TabbarViewDelegate).reloadTab(self)
		}
	}
	
//	MARK:- PanGesture
	
	@objc func handlePan(_ panGesture: UIPanGestureRecognizer) {
	
		let point = panGesture.location(in: self)
		//MFLog.e("Touched point : \(point)")
		
		if (panGesture.state == .began) {
			mPanCurrentPoint = point
			return
		}
		
		if (panGesture.state == .ended) {
			updateActiveTab()
			return
		}
		
		mPanPreviousPoint = mPanCurrentPoint
		mPanCurrentPoint = point
		
		let swipeDirection = getSwipeDirection(from: mPanPreviousPoint, to: mPanCurrentPoint)
		
		if (swipeDirection != .Vertical) {
			let diff = mPanCurrentPoint.x - mPanPreviousPoint.x
			moveTabs(by: diff)
		}
	}
	
//	MARK:- Tab
	
	private func add(tab view: UIView) {
		
		self.addSubview(view)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.topAnchor.constraint(equalTo: self.mTitleView.bottomAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		
		if (mTabArray.count == 0) {
			
			mLeadingConstraint = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
			mLeadingConstraint?.isActive = true
			view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
			mActiveView = view
			
			(view as! TabbarViewDelegate).viewSelected(self)
		
		} else {
			
			let prevTab = mTabArray.last
			view.leadingAnchor.constraint(equalTo: prevTab!.trailingAnchor).isActive = true
			view.widthAnchor.constraint(equalTo: prevTab!.widthAnchor).isActive = true
		}
		
		self.mTabArray.append(view)
	}
	
//	MARK: - TitleView
	
	private func addTitle(tabbar tab: TabbarViewDelegate) {
		
		let button = UIButton()
		button.backgroundColor = kTitleBGColor
		button.addShadow()
		button.addTarget(nil, action: #selector(onTitleClick), for: .touchUpInside)
		button.tag = kTitleIndex + mTitleView.arrangedSubviews.count
		
		if (tab.icon != nil ) {
			button.setImage(tab.icon, for: .normal)
			button.setImage(tab.icon, for: .highlighted)
			button.imageView?.contentMode = .scaleAspectFit
			button.imageEdgeInsets = UIEdgeInsets(top: kEdgeInset, left: kEdgeInset, bottom: kEdgeInset, right: kEdgeInset)
			
		} else{
			button.setTitle(tab.title, for: .normal)
		}
		
		mTitleView.addArrangedSubview(button)
		
		if (mTitleView.arrangedSubviews.count == 1) { addTitleLine() }
	}
	
	private func addTitleLine() {
	
		mTitleLine = UIView()
		mTitleLine.backgroundColor = UIColor.white
		self.addSubview(mTitleLine)
		
		mTitleLine.translatesAutoresizingMaskIntoConstraints = false
		mLineLConstraint = mTitleLine.leadingAnchor.constraint(equalTo: mTitleView.leadingAnchor)
		mLineLConstraint!.isActive = true
		mTitleLine.bottomAnchor.constraint(equalTo: mTitleView.bottomAnchor).isActive = true
		mTitleLine.widthAnchor.constraint(equalTo: mTitleView.arrangedSubviews.first!.widthAnchor).isActive = true
		mTitleLine.heightAnchor.constraint(equalToConstant: kLineHeight).isActive = true
		mTitleLine.layoutIfNeeded()
	}
	
	@objc func onTitleClick(sender: Any) {
		
		let index = (sender as! UIButton).tag - kTitleIndex
		switchToTab(atIndex: index)
	}
	
//	MARK:- Initial
	
	private func addPenGesture() {
		
		mPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
		mPanGesture.maximumNumberOfTouches = Int.max
		self.addGestureRecognizer(mPanGesture)
	}
	
	private func addTitleView() {
		
		mTitleView = UIStackView()
		mTitleView.axis = .horizontal
		mTitleView.distribution = .fillEqually
		mTitleView.alignment = .center
		mTitleView.clipsToBounds = false
		addSubview(mTitleView)
		
		addConstraint(view: mTitleView, relatedToView: self, bottom: false)
		mTitleView.heightAnchor.constraint(equalToConstant: kTitleHeight).isActive = true
		mTitleView.layoutIfNeeded()
	}
	
//	MARK: - Utility
	
	private func updateActiveTab() {
	
		if (mLeadingConstraint == nil) { return	}
		
		let cons = mLeadingConstraint!.constant
		let index = mTabArray.index(of: mActiveView!)!
		mLeadingConstraint!.isActive = false
		
		if (cons < 0 && abs(cons) > mActiveView!.frame.size.width/2 ) {
			
			mPrevActiveView = mActiveView
			mActiveView = mTabArray[index + 1]
			reloadTab()
		}
		
		if (cons > mActiveView!.frame.size.width/2 ) {
			
			mPrevActiveView = mActiveView
			mActiveView = mTabArray[index - 1]
			reloadTab()
		}
		
		mLeadingConstraint = mActiveView!.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		mLeadingConstraint?.isActive = true
		
		updateLine()
		
		UIView.animate(withDuration: 0.2) { [unowned self] in
			self.layoutIfNeeded()
		}
	}
	
	private func updateLine() {
		
		let index = mTabArray.index(of: mActiveView!)!
		let view = mTitleView.arrangedSubviews[index]
		
		mLineLConstraint!.isActive = false
		mLineLConstraint = mTitleLine.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		mLineLConstraint?.isActive = true
	}
	
	private func switchToTab(atIndex index: Int) {
	
		if (mLeadingConstraint == nil) { return	}
		
		mLeadingConstraint!.isActive = false
	
		mPrevActiveView = mActiveView
		mActiveView = mTabArray[index]
		reloadTab()
		
		mLeadingConstraint = mActiveView!.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		mLeadingConstraint?.isActive = true

		//	Line
		
		let view = mTitleView.arrangedSubviews[index]
		mLineLConstraint!.isActive = false
		self.mLineLConstraint = self.mTitleLine.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		self.mLineLConstraint?.isActive = true
		
		UIView.animate(withDuration: 0.4) { [unowned self] in
			self.layoutIfNeeded()
		}
	}
	
	private func reloadTab() {
		
		(mPrevActiveView as! TabbarViewDelegate).viewDidDisappear(self)
		(mActiveView as! TabbarViewDelegate).viewSelected(self)		
	}
	
	private func moveTabs(by diff:CGFloat) {
		
		if	(diff == 0) ||
			(mLeadingConstraint == nil ) ||
			(mActiveView == mTabArray.first && diff > 0 && mLeadingConstraint!.constant >= 0) ||
			(mActiveView == mTabArray.last && diff < 0 && mLeadingConstraint!.constant <= 0) {
			return
		}
		
		mLeadingConstraint!.constant += diff
		
		let lineDiff = (-diff)/CGFloat(mTabArray.count)
		mLineLConstraint!.constant += lineDiff
	}
	
	private func getSwipeDirection(from pointA:CGPoint, to pointB:CGPoint) -> EDirection {
		
		return (pointB.x < pointA.x) ? .Left : ((pointB.x > pointA.x) ? .Right : .Vertical)
	}
	
	private func addConstraint(view: UIView, relatedToView superView: UIView, bottom: Bool = true) {
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
		view.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
		view.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
		
		if (bottom) {view.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true }
	}
}
