//
//
//
// Created by: Patrik Drab on 30/04/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


struct StationTableVM: Hashable {
    let station: CDStation
    var minutesToDisplay: String?
    
    init(station: CDStation, minutesToDisplay: String? = nil) {
        self.station = station
        self.minutesToDisplay = minutesToDisplay
    }
}

class StationsTable: UIView, UITableViewDelegate, UIGestureRecognizerDelegate {
    static let reuseIdentifier = "StationsTable"

    private let stationTableView = UITableView()
    
    private var data: [StationTableVM] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    private var dataSource: UITableViewDiffableDataSource<Int, StationTableVM>!
    
    private var initialIndexPath: IndexPath?
    private var lastActivatedIndexPath: IndexPath?
    
    // MARK: Indicator Line properties
    private let rowHeight: CGFloat = 50
    private let lineWidth: CGFloat = 4
    private let circleDiameter: CGFloat = 16
    
    init() {
        super.init(frame: .zero)
        setupTable()
        configureDataSource()
        applySnapshot()
        setupTouchHandling()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTable()
        configureDataSource()
        applySnapshot()
        setupTouchHandling()
    }
    
    private func setupTable() {
        stationTableView.register(StationViewCell.self, forCellReuseIdentifier: StationViewCell.reuseIdentifier)
        stationTableView.separatorStyle = .none
        stationTableView.showsHorizontalScrollIndicator = false
        stationTableView.showsVerticalScrollIndicator = false
        stationTableView.delegate = self
        stationTableView.backgroundColor = .systemBackground
        
        addSubview(stationTableView)
        stationTableView.pinInSuperview()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, StationTableVM>(tableView: stationTableView) { tableView, indexPath, station in
            let row = tableView.dequeueReusableCell(withIdentifier: StationViewCell.reuseIdentifier, for: indexPath) as! StationViewCell
            row.formatRow(with: station, index: indexPath.row)
            
            return row
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StationTableVM>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupTouchHandling() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.2
        longPress.delegate = self
        stationTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: stationTableView)
        switch gesture.state {
        case .began:
            if let indexPath = stationTableView.indexPathForRow(at: location) {
                initialIndexPath = indexPath
                lastActivatedIndexPath = indexPath
                updateStationTimesFrom(at: indexPath)
                highlightRow(at: indexPath, isHighlighted: true)
            }
        case .changed:
            if let initialIndexPath = initialIndexPath {
                highlightRow(at: initialIndexPath, isHighlighted: true)
            }
        case .ended, .cancelled:
            
            if let indexPath = self.initialIndexPath {
                self.highlightRow(at: indexPath, isHighlighted: false)
                self.resetAllStationTimes()
            }
            
            initialIndexPath = nil
            lastActivatedIndexPath = nil
        default:
            break
        }
    }
    
    private func highlightRow(at indexPath: IndexPath, isHighlighted: Bool) {
        guard let row = stationTableView.cellForRow(at: indexPath) as? StationViewCell else { return }
        row.isHighlighted = isHighlighted
        row.updateAppearance()
    }
    
    private func updateStationTimesFrom(at indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            var minutes = 0
            
            for (index, item) in data.enumerated() {
                if index < indexPath.row {
                    data[index].minutesToDisplay = nil
                } else {
                    data[index].minutesToDisplay = "\(minutes)'"
                    minutes += Int(item.station.travelTimeToNextStop)
                }
            }
            
            applySnapshot(animatingDifferences: false)
        }
    }
    
    private func resetAllStationTimes() {
        UIView.performWithoutAnimation {
            for index in 0..<data.count {
                data[index].minutesToDisplay = nil
            }
            applySnapshot(animatingDifferences: false)
        }
    }
    
    func update(with stations: [CDStation]) {
        self.data = stations.enumerated().map { index, station in
            return StationTableVM(station: station, minutesToDisplay: nil)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupIndicatorLine()
    }
    
    private func setupIndicatorLine() {
        let totalTableHeight = CGFloat(stationTableView.numberOfRows(inSection: 0)) * rowHeight
        let totalIndicatorLineHeight = totalTableHeight - 50
        let circlePadding = rowHeight/2 - circleDiameter/2
  
        let indicatorContainer = UIView()
        indicatorContainer.setDimensions(width: 42, height: totalTableHeight)
        stationTableView.addSubview(indicatorContainer)
        
        createLineIndicator(in: indicatorContainer, height: totalIndicatorLineHeight)
        createPositionMarkers(in: indicatorContainer, padding: circlePadding)
    }
    
    private func createLineIndicator(in container: UIView, height: CGFloat) {
        let indicatorLineBorder = UIView(color: .white)
        indicatorLineBorder.setDimensions(width: lineWidth, height: height)
        container.addSubview(indicatorLineBorder)
        indicatorLineBorder.center()
        
        let indicatorLine = UIView(color: .systemGray)
        indicatorLine.setDimensions(width: lineWidth/2, height: height - 2)
        indicatorLineBorder.addSubview(indicatorLine)
        indicatorLine.center()
    }
    
    private func createPositionMarkers(in container: UIView, padding: CGFloat) {
        let topCircle = UIView(color: .systemGray)
        topCircle.setSize(.equalEdge(circleDiameter))
        topCircle.setCornerRadius(radius: circleDiameter/2)
        container.addSubview(topCircle)
        topCircle.top(offset: .init(x: 0, y: padding))
        
        let bottomCircle = UIView(color: .systemGray)
        bottomCircle.setSize(.equalEdge(circleDiameter))
        bottomCircle.setCornerRadius(radius: circleDiameter/2)
        container.addSubview(bottomCircle)
        bottomCircle.bottom(offset: .init(x: 0, y: padding))
    }
}

extension StationsTable {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parrentVC = self.findViewController() {
            let station = data[indexPath.row].station
            let timetableVC = TimeTableViewController(station: station)
            parrentVC.navigationController?.pushViewController(timetableVC, animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
