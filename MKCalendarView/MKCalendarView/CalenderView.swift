//
//  CalenderView.swift
//  CalendarView
//
//  Created by mk mk on 3/8/19.
//  Copyright © 2019 MC2. All rights reserved.
//

import UIKit

public class CalenderView: UIView {

	// MARK: - Properties
	// - Constants
	// Weekday stack height
	private let weekdayH: CGFloat = 44
	// Default cell size
	private let defaultSize: CGFloat = 25
	
	
	// - Variables
	// Tint color
	private var calTintColor: UIColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
	// Data model
	private var model = CalendarModel()
	// Selected indexpath reference
	private var selectedIndexpath: IndexPath?
	
	// - Closure
	var selectedDate: ((Date) -> Void)?
	
	// MARK: - Views
	// Month label
	private(set) lazy var monthLabel: UILabel = {
		let lb = UILabel()
		lb.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		lb.textColor = calTintColor
		return lb
	}()
	
	// Previous button
	private lazy var prevBtn: UIButton = {
		let btn = UIButton(type: .custom)
		btn.setImage(#imageLiteral(resourceName: "Arrow").withRenderingMode(.alwaysTemplate), for: .normal)
		btn.tintColor = calTintColor
		return btn
	}()
	
	// Next Button
	private lazy var nextBtn: UIButton = {
		let btn = UIButton(type: .custom)
		btn.setImage(#imageLiteral(resourceName: "Arrow").withRenderingMode(.alwaysTemplate), for: .normal)
		btn.tintColor = calTintColor
		return btn
	}()
	
	// Weekday stack
	private lazy var weekdayStack = WeekdayStack(color: calTintColor)
	
	// Calendar collection
	private lazy var calendarCollection: UICollectionView = {
		// Layout
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: defaultSize, height: defaultSize)
		
		// Collection view
		let cc = UICollectionView(frame: .zero, collectionViewLayout: layout)
		return cc
	}()

	// MARK: - OVerride init
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
}

// MARK: - Public function
extension CalenderView {
	
	
	
}

// MARK: - Private function
extension CalenderView {
	
	// Update calendar
	private func updateCalendar() {
		// Update month label
		model.updateMonthLabel(label: monthLabel)
		calendarCollection.reloadData()
	}
	
}

// MARK: - Actions
extension CalenderView {
	// Last month action
	@objc private func lastMonthAction() {
		print("Last month")
		model.prevMonth()
	}
	
	// Next month action
	@objc private func nextMonthAction() {
		print("Next month")
		model.nextMonth()
	}
}

// MARK: - Delegate
// MARK: - CollectionView delegate / data source
extension CalenderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	// Number of cells
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model.cellsInMonth()
	}
	
	// Configure cell
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return model.configureCell(collectionView, indexPath)
	}
	
	// Select cell
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("asfdafad")
		let cell = collectionView.cellForItem(at: indexPath) as! DateCell
		print("cell: \(cell)")
		let selectedDate = cell.selectCell()
		self.selectedDate?(selectedDate)
		
		// Deselect last selected cell
		if selectedIndexpath != nil {
			if selectedIndexpath != indexPath {
				let lastSelectCell = collectionView.cellForItem(at: selectedIndexpath!) as! DateCell
				lastSelectCell.deselectCell()
			}
		}
		selectedIndexpath = indexPath
		
	}
	
	// Cell size
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = collectionView.frame.width / 7
		return CGSize(width: size, height: size)
	}
}

// MARK: - Setup
extension CalenderView {
	private func setup() {
		// Setup UI
		setupUI()
		
		// Assign closure
		model.updateCalendar = updateCalendar
		// Update month label
		model.updateMonthLabel(label: monthLabel)
	}
	
	
	private func setupUI() {
		// Month label
		addSubview(monthLabel)
		monthLabel.translatesAutoresizingMaskIntoConstraints = false
		monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Padding.p10).isActive = true
		monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		
		// Previous button
		prevBtn.addTarget(self, action: #selector(lastMonthAction), for: .touchUpInside)
		addSubview(prevBtn)
		prevBtn.translatesAutoresizingMaskIntoConstraints = false
		prevBtn.heightAnchor.constraint(equalTo: monthLabel.heightAnchor).isActive = true
		prevBtn.widthAnchor.constraint(equalTo: prevBtn.heightAnchor).isActive = true
		prevBtn.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor).isActive = true
		prevBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.p20).isActive = true
		
		// Next button
		nextBtn.addTarget(self, action: #selector(nextMonthAction), for: .touchUpInside)
		nextBtn.transform = nextBtn.transform.rotated(by: .pi)
		addSubview(nextBtn)
		nextBtn.translatesAutoresizingMaskIntoConstraints = false
		nextBtn.heightAnchor.constraint(equalTo: monthLabel.heightAnchor).isActive = true
		nextBtn.widthAnchor.constraint(equalTo: nextBtn.heightAnchor).isActive = true
		nextBtn.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor).isActive = true
		nextBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.p20).isActive = true
		
		// Weekday stack view
		addSubview(weekdayStack)
		weekdayStack.translatesAutoresizingMaskIntoConstraints = false
		weekdayStack.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: Padding.p10).isActive = true
		weekdayStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		weekdayStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		weekdayStack.heightAnchor.constraint(equalToConstant: weekdayH).isActive = true
		
		// Calendar collection
		calendarCollection.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		calendarCollection.delegate = self
		calendarCollection.dataSource = self
		calendarCollection.register(DateCell.self, forCellWithReuseIdentifier: model.cellID)
		addSubview(calendarCollection)
		calendarCollection.translatesAutoresizingMaskIntoConstraints = false
		calendarCollection.topAnchor.constraint(equalTo: weekdayStack.bottomAnchor).isActive = true
		calendarCollection.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		calendarCollection.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		calendarCollection.heightAnchor.constraint(equalTo: calendarCollection.widthAnchor, multiplier: 6/7).isActive = true 
	}
}
