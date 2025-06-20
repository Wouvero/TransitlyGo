//
//
//
// Created by: Patrik Drab on 14/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

struct StationViewModel: Hashable {
    let station: MHD_DirectionStation
    var minutesToDisplay: String?
    
    init(station: MHD_DirectionStation, minutesToDisplay: String? = nil) {
        self.station = station
        self.minutesToDisplay = minutesToDisplay
    }
    
    static func makeViewModels(with stations: [MHD_DirectionStation]) -> [StationViewModel] {
        return stations.enumerated().map { index, station in
            StationViewModel(station: station, minutesToDisplay: nil)
        }
    }
}

class RouteStationsTable: UIView {
    static let reuseIdentifier = "StationsTable"

    let tableView = UITableView()
    
    private var initialIndexPath: IndexPath?
    private var lastActivatedIndexPath: IndexPath?
    
    private var data: [StationViewModel] = []
    
    init(with stations: [MHD_DirectionStation]) {
        super.init(frame: .zero)
        setupView()
        data = StationViewModel.makeViewModels(with: stations)
        setupTouchHandling()
        setupRouteIndicatorLine()
    }
    
    deinit {
        data = []
        initialIndexPath = nil
        lastActivatedIndexPath = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        configureTableView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureTableView() {
  
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //tableView.backgroundColor = .systemBlue
        tableView.register(RouteStationViewCell.self, forCellReuseIdentifier: RouteStationViewCell.reuseIdentifier)
        
        // Prevent estimated heights before view is in hierarchy
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        // Only perform layout if we're in the window hierarchy
        if window != nil {
            // Only set delegate/dataSource when in window hierarchy
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        } else {
            // Clean up when leaving hierarchy
            tableView.delegate = nil
            tableView.dataSource = nil
        }
    }
}

extension RouteStationsTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteStationViewCell.reuseIdentifier, for: indexPath) as! RouteStationViewCell
        let index = indexPath.row
        let station = data[index]
        
        cell.formatRow(with: station, index: indexPath.row)
        
        return cell
    }
    
}

extension RouteStationsTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parrentVC = self.findViewController() {
            let station = data[indexPath.row].station
            let timetableVC = TimeTableViewController(station: station)
            
            parrentVC.navigationController?.pushViewController(timetableVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RouteStationViewCell.Constants.cellHeight
    }
    
}

extension RouteStationsTable: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupTouchHandling() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.2
        longPress.delegate = self
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: tableView)
        switch gesture.state {
        case .began:
            if let indexPath = tableView.indexPathForRow(at: location) {
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
        guard let cell = tableView.cellForRow(at: indexPath) as? RouteStationViewCell else { return }
        cell.isHighlighted = isHighlighted
        cell.updateAppearance()
    }
    
    private func updateStationTimesFrom(at indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            var minutes = 0
            
            for (index, item) in data.enumerated() {
                if index < indexPath.row {
                    data[index].minutesToDisplay = nil
                } else {
                    data[index].minutesToDisplay = "\(minutes)'"
                    minutes += Int(item.station.travelTimeToNextStation)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    private func resetAllStationTimes() {
        UIView.performWithoutAnimation {
            for index in 0..<data.count {
                data[index].minutesToDisplay = nil
            }
            tableView.reloadData()
        }
    }
    
}

extension RouteStationsTable {
    
    private func setupRouteIndicatorLine() {
        let cellHeight = RouteStationViewCell.Constants.cellHeight
        for i in 0..<data.count {
            
            let circlePosX: CGFloat = 16 + 44/2 - 8
            let circlePosY: CGFloat = CGFloat(i)*cellHeight + (cellHeight/2 - 8)
            
            let circle = UIView(frame: .init(x: circlePosX, y: circlePosY, width: 16, height: 16))
            circle.backgroundColor = .neutral600
            circle.setCornerRadius(radius: 8)
            
            tableView.addSubview(circle)
            
            if i < data.count - 1 {
                let linePosX: CGFloat = 16 + 44/2 - 1
                let linePosY: CGFloat = circlePosY + 16 + 3
                
                let line = UIView(frame: .init(x: linePosX, y: linePosY, width: 2, height: 22))
                line.backgroundColor = .neutral600
                tableView.addSubview(line)
            }
        }
    }

}
