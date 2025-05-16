//
//
//
// Created by: Patrik Drab on 23/03/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitTools


struct Station_1: Hashable {
    let stationName: String
    let isOnSign: Bool
    let minutesToAnotherStation: Int
    var minutesToDisplay: String?
}

extension Station_1 {
    static let allStations: [Station_1] = [
        Station_1(stationName: "Central Terminal", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Riverside Junction", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Grand Union", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Westfield Plaza", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Highland Cross", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Pioneer Square", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Sunset Valley", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Northgate Hub", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Main Street Terminal", isOnSign: true, minutesToAnotherStation: 1),
        Station_1(stationName: "Union Transfer", isOnSign: true, minutesToAnotherStation: 1),
        Station_1(stationName: "Greenfield Park", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Lakeside District", isOnSign: false, minutesToAnotherStation: 2),
        Station_1(stationName: "Midtown Crossing", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Harborview Point", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Eastbank Station", isOnSign: false, minutesToAnotherStation: 1),
        Station_1(stationName: "Terminus Plaza", isOnSign: true, minutesToAnotherStation: 1),
        Station_1(stationName: "Interchange Central", isOnSign: true, minutesToAnotherStation: 0)
    ]
}


class StationCell: UICollectionViewCell {
    var stationName = UILabel(
        text: "Station name",
        font: UIFont.systemFont(ofSize: 16, weight: .medium),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var minutesLabel = UILabel(
        text: "",
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .black,
        textAlignment: .left,
        numberOfLines: 1
    )
    
    var isOnSignIcon = IconImageView(
        systemName: "hand.raised.fill",
        tintColor: .gray
    )
    
    var iconContainer = UIView()
    
    var cellContainer: UIStackView!
    
    var timeContainer = UIView()
    
    
    private var cellIndex: Int = 0
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Cell Container
        cellContainer = UIStackView(
            arrangedSubviews: [timeContainer, stationName, UIView(), iconContainer],
            axis: .horizontal,
            spacing: 0,
            alignment: .leading,
            distribution: .fillProportionally
        )
        cellContainer.paddingLeft(42)
        cellContainer.paddingRight(16)
        
        
      
        
        addSubviews(cellContainer)
        cellContainer.pinInSuperview()
        
        
        stationName.setHeight(50)
        
        iconContainer.setSize(.equalEdge(50))
        iconContainer.addSubview(isOnSignIcon)
        isOnSignIcon.centerInSuperview()
        
        timeContainer.setDimensions(width: 50, height: 50)
        timeContainer.addSubview(minutesLabel)
        minutesLabel.center()
        
        minutesLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
       
    }
    
    private func updateAppearance() {
        if isHighlighted {
            // Highlighted state
            backgroundColor = .systemBlue.withAlphaComponent(0.2)
            stationName.textColor = .systemBlue
            minutesLabel.textColor = .systemBlue
            isOnSignIcon.setTintColor(.systemBlue)
        } else {
            // Normal state based on index
            backgroundColor = cellIndex.isMultiple(of: 2) ? .systemGray5 : .systemGray6
            stationName.textColor = .black
            minutesLabel.textColor = .black
            isOnSignIcon.setTintColor(.gray)
        }
    }
    
    
    func formatCell(with station: Station_1, index: Int) {
        cellIndex = index
        stationName.text = station.stationName
        iconContainer.isHidden = station.isOnSign ? false : true
        updateAppearance()
    }
    
    func showMinutes(_ minutes: String?) {
        minutesLabel.text = minutes
        minutesLabel.isHidden = (minutes == nil || minutes?.isEmpty == true)
    }
}


class StationsList: UIView, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    
    let columnGap: CGFloat = 0
    let rowGap: CGFloat = 0
    let itemsInRow: CGFloat = 1
    
    private var data = Station_1.allStations
    private var dataSource: UICollectionViewDiffableDataSource<Int, Station_1>!
    
    
    init() {
        super.init(frame: .zero)
        setupCollection()
        configureDataSource()
        applySnapshot()
        setupTouchHandling()
    }
    
    private func setupCollection() {
        layout.minimumInteritemSpacing = columnGap
        layout.minimumLineSpacing = rowGap
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.register(StationCell.self, forCellWithReuseIdentifier: StationCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delaysContentTouches = false
        
        addSubviews(collectionView)
        collectionView.pinInSuperview()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Station_1>(collectionView: collectionView) { collectionView, indexPath, station in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationCell.reuseIdentifier, for: indexPath) as! StationCell
            cell.formatCell(with: station, index: indexPath.row)
            return cell
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Station_1>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemWidth = (bounds.width) / itemsInRow - columnGap
        layout.itemSize = CGSize(width: itemWidth, height: 50)
        collectionView.collectionViewLayout.invalidateLayout()
        
        collectionView.layoutIfNeeded() // Force layout calculation
        let totalContentSize = collectionView.contentSize
        //print("Total content size: \(totalContentSize.height)")
        
        
        let indicatorContainer = UIView()
        collectionView.addSubview(indicatorContainer)
        indicatorContainer.setDimensions(width: 42, height: totalContentSize.height)
        
        
        let indicator = UIView(color: .black)
        indicatorContainer.addSubview(indicator)
        indicator.setDimensions(width: 4, height: totalContentSize.height - 50)
        indicator.setBorder(width: 1, color: .white)
        indicator.center()
        
        let topCircle = UIView(color: .black)
        topCircle.setDimensions(width: 16, height: 16)
        topCircle.setCornerRadius(radius: 8)
        indicatorContainer.addSubview(topCircle)
        topCircle.top(offset: .init(x: 0, y: 25 - 8))
        
        
        let bottomCircle = UIView(color: .black)
        bottomCircle.setDimensions(width: 16, height: 16)
        bottomCircle.setCornerRadius(radius: 8)
        indicatorContainer.addSubview(bottomCircle)
        bottomCircle.bottom(offset: .init(x: 0, y: 25 - 8))
    }
    
    // Touch tracking properties
    private var initialIndexPath: IndexPath?
    private var lastActivatedIndexPath: IndexPath?
    
    private func setupTouchHandling() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.05
        longPressRecognizer.delegate = self
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                initialIndexPath = indexPath
                lastActivatedIndexPath = indexPath
                highlightCell(at: indexPath, isHighlighted: true)
                updateStationTimesFrom(at: indexPath)
            }
            
        case .changed:
            // Continue highlighting the initial cell while scrolling/moving
            if let initialIndexPath = initialIndexPath {
                highlightCell(at: initialIndexPath, isHighlighted: true)
            }
            
        case .ended, .cancelled:
            if let indexPath = initialIndexPath {
                highlightCell(at: indexPath, isHighlighted: false)
                resetAllStationTimes()
                
                // Check if touch ended on the same cell
                if let endIndexPath = collectionView.indexPathForItem(at: location),
                   endIndexPath == indexPath {
                    collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                }
            }
            initialIndexPath = nil
            lastActivatedIndexPath = nil
            
        default:
            break
        }
    }
    
    private func highlightCell(at indexPath: IndexPath, isHighlighted: Bool) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StationCell else { return }
        cell.isHighlighted = isHighlighted
    }
    
    private func updateStationTimesFrom(at indexPath: IndexPath) {
        var minutes = 0
        
        resetAllStationTimes()
        
        for (index, item) in data.enumerated() {
            let currentIndexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: currentIndexPath) as? StationCell {
                if index < indexPath.row {
                    cell.showMinutes("")
                } else {
                    cell.showMinutes("\(minutes)'")
                    minutes += item.minutesToAnotherStation
                }
            }
        }
    }
    
    private func resetAllStationTimes() {
        for index in 0..<data.count {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? StationCell {
                cell.showMinutes(nil)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StationsList: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



class StationsViewController: UIViewController {
    private let stationsList = StationsList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(stationsList)
        stationsList.pinInSuperview(padding: .vertical(0))
        
        
    }
}

import SwiftUI

struct StationsViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview{StationsViewController()}
            .ignoresSafeArea(.all)
    }
}

