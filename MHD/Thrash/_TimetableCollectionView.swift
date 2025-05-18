//
//
//
// Created by: Patrik Drab on 02/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit


class TimetableCollectionView: UIView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CDHourlyInfo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CDHourlyInfo>
    
    private var collectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()

    let columnGap: CGFloat = 0
    let rowGap: CGFloat = 0
    let itemsInRow: CGFloat = 1


    private var data: [CDHourlyInfo] = [] {
        didSet {
            applySnapshot()
        }
    }

    private var dataSource: DataSource!

    init() {
        super.init(frame: .zero)
        setupCollection()
        configureDataSource()
        applySnapshot()
    }

    private func setupCollection() {
        layout.minimumInteritemSpacing = columnGap
        layout.minimumLineSpacing = rowGap
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

//        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            TimetableCollectionViewCell.self,
            forCellWithReuseIdentifier: TimetableCollectionViewCell.reuseIdentifier)

        addSubviews(collectionView)
        collectionView.pinInSuperview()
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, departure in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCollectionViewCell.reuseIdentifier, for: indexPath) as! TimetableCollectionViewCell
            cell.configure(with: departure, index: indexPath.row)

            return cell
        }
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(data)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let itemWidth = (bounds.width) / itemsInRow - columnGap
        layout.itemSize = CGSize(width: itemWidth, height: 50)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(with departures: [CDHourlyInfo]) {
        self.data = departures
    }
}

