//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit
import UIKitPro

class TransportLinesCollectionView: UIView {
    static let reuseIdentifier = "TransportLinesCollectionView"
    
    private var collectionView: UICollectionView!
    
    private let layout = UICollectionViewFlowLayout()
    private let columnGap: CGFloat = 0
    private let rowGap: CGFloat = 1
    private let itemsInRow: CGFloat = 6
    
    private var numberOfTransportLines: Int? = nil
    
    private var data: [MHD_TransportLine] = [] {
        didSet {
            numberOfTransportLines = data.count
            applySnapshot()
        }
    }
    private var dataSource: DataSource!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollection()
        configureDataSource()
        applySnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(frame:) instead. This controller doesn't support Storyboards.")
    }
    
    func update(with lines: [MHD_TransportLine]) {
        self.data = lines
    }
}


// MARK: - Layout
extension TransportLinesCollectionView {
    struct LayoutConfiguration {
        var itemsInRow: CGFloat = 6
        var rowSpacing: CGFloat = 1
        var columnSpacing: CGFloat = 0
        var aspectRatio: CGFloat = 0.75 // width:height ratio
    }
    
    private func setupCollection() {
        layout.minimumInteritemSpacing = columnGap
        layout.minimumLineSpacing = rowGap
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.register(
            TransportLineCell.self,
            forCellWithReuseIdentifier: TransportLineCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.pinInSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemWidth = (bounds.width) / itemsInRow - columnGap
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.75)
        
        // Called collectionView.collectionViewLayout.invalidateLayout() to apply new sizes.
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Data handling
private extension TransportLinesCollectionView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MHD_TransportLine>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MHD_TransportLine>
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransportLineCell.reuseIdentifier, for: indexPath) as! TransportLineCell
            
            var shouldDrawBorder: Bool = false
            
            let maximumNumberOfItemsInRow = Int(self.itemsInRow)
            let indexItem = indexPath.row
            
            if
                let numberOfTransportLines = self.numberOfTransportLines,
                numberOfTransportLines > maximumNumberOfItemsInRow {
                shouldDrawBorder = indexItem <= numberOfTransportLines - maximumNumberOfItemsInRow
                    ? true
                    : false
            }
            
            cell.configure(with: item, shouldShowBorder: shouldDrawBorder)
            return cell
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        // Create a snapshot
        var snapshot = Snapshot()
        
        // Add sections and items
        snapshot.appendSections([0]) // Only one section
        snapshot.appendItems(data)   // Add all items from the data array
        
        // Apply the snapshot
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}


// MARK: - Delegate
extension TransportLinesCollectionView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTrasportLine = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let parrentVC = self.findViewController() {
            let routeVC = DirectionsViewController(for: selectedTrasportLine)
            parrentVC.navigationController?.pushViewController(routeVC, animated: true)
        }
    }
    
}
