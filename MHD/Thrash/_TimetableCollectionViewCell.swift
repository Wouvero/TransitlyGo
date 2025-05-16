//
//
//
// Created by: Patrik Drab on 02/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitTools

class TimetableCollectionViewCell: UICollectionViewCell {

    private let hourLabel = UILabel(
        font: .boldSystemFont(ofSize: 16)
    )
    private var hourView = UIView()

    private var cellIndex: Int = 0

    private var cellContainer: UIStackView!
    private var minutesContainer: UIStackView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView () {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        hourView = createHourView()
//
//        let devider = UIView(color: .gray)
//        devider.setDimensions(width: 1, height: 50)
//
//        minutesContainer = UIStackView(
//            arrangedSubviews: [UIView()],
//            axis: .vertical,
//            spacing: 0,
//            alignment: .leading,
//            distribution: .fill
//        )
//
//        cellContainer = UIStackView(
//            arrangedSubviews: [
//                hourView, devider, minutesContainer
//            ],
//            axis: .horizontal,
//            spacing: 0,
//            alignment: .leading,
//            distribution: .fill
//        )
//
//
//        addSubviews(cellContainer)
//        cellContainer.pinInSuperview()

//        let v = UIView(color: .systemBlue)
//        addSubviews(v)
//        v.pinInSuperview()
//        v.addSubview(hourView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }


    func configure(with departure: CDHourlyDeparture, index: Int) {
//        guard hourLabel.text != "\(departure.hour)" || cellIndex != index else { return }
//
//        cellIndex = index
//        hourLabel.text = "\(departure.hour)"
//        updateAppearance()

//        minutesContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        let availbaleWidth = UIScreen.main.bounds.width - 50
//        let availableMinuteViewWidth:CGFloat = 50
//        //print(availableMinuteViewWidth)
//        var currentRow = createMinutesRow()
//        var currentRowWidth: CGFloat = 0
//
//        for (index, minute) in departure.enumerated() {
//
//            if currentRowWidth + availableMinuteViewWidth > availbaleWidth {
//                minutesContainer.addArrangedSubview(currentRow)
//                currentRow = createMinutesRow()
//                currentRowWidth = 0
//            }
//
//            let minuteView = createMinuteView(text: minute, width: availableMinuteViewWidth)
//            currentRow.addArrangedSubview(minuteView)
//            if index + 1 < departure.formatedMinutes.count {
//                currentRow.addArrangedSubview(UILabel(text: ","))
//            }
//            currentRowWidth += availableMinuteViewWidth
//        }
//
//        if !currentRow.arrangedSubviews.isEmpty {
//            minutesContainer.addArrangedSubview(currentRow)
//        }
    }

//    private func createMinutesRow() -> UIStackView {
//        let minutesRow = UIStackView(
//            arrangedSubviews: [],
//            axis: .horizontal,
//            spacing: 0,
//            alignment: .center,
//            distribution: .fill
//        )
//
//        return minutesRow
//    }
//
//    private func createMinuteView(text: String, width: CGFloat) -> UIView {
//        let minuteView = UIView()
//        let minuteLabel = UILabel(text: text)
//        //minuteView.setBackground(.cyan)
//        minuteView.setDimensions(width: 50, height: 50)
//
//        minuteView.addSubview(minuteLabel)
//        minuteLabel.center()
//
//        return minuteView
//    }

    private func createHourView() -> UIView {
        let hourView = UIView()
        hourView.setDimensions(width: 50, height: 50)

        hourView.addSubview(hourLabel)
        hourLabel.center()

        return hourView
    }

    private func updateAppearance() {
        backgroundColor = cellIndex.isMultiple(of: 2) ? .systemGray5 : .systemGray6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
