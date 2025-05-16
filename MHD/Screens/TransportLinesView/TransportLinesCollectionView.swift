//
//
//
// Created by: Patrik Drab on 29/04/2025
// Copyright (c) 2025 MHD
//
//

import UIKit

class TransportLinesCollectionView: UIView {
    static let reuseIdentifier = "TransportLinesCollectionView"
    
    private var collectionView: UICollectionView!
    
    private let layout = UICollectionViewFlowLayout()
    private var columnGap: CGFloat = 3 {
        didSet {
            layout.minimumInteritemSpacing = columnGap
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private var rowGap: CGFloat = 3 {
        didSet {
            layout.minimumLineSpacing = rowGap
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private var itemsInRow: CGFloat = 6 {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private var data: [CDTransportLine] = [] {
        didSet {
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
    
    func update(with lines: [CDTransportLine]) {
        self.data = lines
    }
}


// MARK: - Layout
extension TransportLinesCollectionView {
    struct LayoutConfiguration {
        var itemsInRow: CGFloat = 6
        var rowSpacing: CGFloat = 3
        var columnSpacing: CGFloat = 3
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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CDTransportLine>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CDTransportLine>
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransportLineCell.reuseIdentifier, for: indexPath) as! TransportLineCell
            cell.configure(with: item)
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
            let routeVC = RoutesViewController(for: selectedTrasportLine)
            parrentVC.navigationController?.pushViewController(routeVC, animated: true)
        }
    }
    
}
