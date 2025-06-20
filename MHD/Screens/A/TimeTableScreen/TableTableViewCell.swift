//
//
//
// Created by: Patrik Drab on 14/05/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import UIKitPro

class TimeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TimeTableViewCell"
    
    enum Constants {
        static let cellHeight: CGFloat = 44
        static let timeCellWidth: CGFloat = 50
    }
    
    private var cellIndex: Int = 0
    
    private let departureHourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Constants.cellHeight),
            view.heightAnchor.constraint(equalToConstant: Constants.cellHeight)
        ])
        
        return view
    }()
    
    private var departureHourLabel = UILabel(
        text: "1",
        font: UIFont.interSemibold(size: 16),
        textColor: .neutral800,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private var rootStackView = UIStackView(
        axis: .horizontal,
        spacing: 0,
        alignment: .leading,
        distribution: .fill
    )
    
    private let departureMinutesStack = UIStackView(
        axis: .vertical,
        spacing: 0,
        alignment: .leading,
        distribution: .fill
    )
    
    private var countdownLabel = UILabel(
        font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium),
        textColor: .neutral,
        textAlignment: .right,
        numberOfLines: 1
    )
    
    private let countdownView = UIView(color: .primary500)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell () {
        // Setup hourview
        departureHourView.addSubview(departureHourLabel)
        departureHourLabel.translatesAutoresizingMaskIntoConstraints = false
        departureHourLabel.centerXAnchor.constraint(equalTo: departureHourView.centerXAnchor).isActive = true
        departureHourLabel.centerYAnchor.constraint(equalTo: departureHourView.centerYAnchor).isActive = true

        addSubviews(rootStackView)
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    
        //setup countdownView
        countdownView.isHidden = true
        countdownView.translatesAutoresizingMaskIntoConstraints = false
        countdownView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        countdownView.heightAnchor.constraint(equalToConstant: Constants.cellHeight).isActive = true
        
        countdownView.addSubview(countdownLabel)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.centerXAnchor.constraint(equalTo: countdownView.centerXAnchor).isActive = true
        countdownLabel.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor).isActive = true
        
        //add content into cellContainer
        rootStackView.addArrangedSubview(departureHourView)
        rootStackView.addArrangedSubview(departureMinutesStack)
        rootStackView.addArrangedSubview(countdownView)
    }
    

    func configure(
        with departure: MHD_TimeTable,
        index: Int,
        currentTable: Bool,
        highlightRowIndex: Int? = nil,
        highlightMinuteIndex: Int? = nil,
        timeRemaining: String? = nil
    ) {
        cellIndex = index
        
        
        rootStackView.backgroundColor = currentTable && (highlightRowIndex == cellIndex)
            ? .neutral800
            : cellIndex.isMultiple(of: 2)
                ? .neutral30
                : .neutral10
        
        departureHourLabel.text = numberToString(departure.hour)
        departureHourLabel.textColor = currentTable && (highlightRowIndex == cellIndex) ? .neutral : .neutral800

        countdownLabel.text = timeRemaining
        countdownView.isHidden = timeRemaining == nil
        
        departureMinutesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let itemMargin: CGFloat = 2
        
        departureMinutesStack.isLayoutMarginsRelativeArrangement = true
        departureMinutesStack.layoutMargins = UIEdgeInsets(top: 0, left: itemMargin, bottom: 0, right: 0)

        
     
        let availbaleWidth = UIScreen.main.bounds.width - Constants.timeCellWidth - 100 - 2
        let availableMinuteViewWidth:CGFloat = Constants.timeCellWidth
        
        var currentRow = createMinutesInfoRow()
        var currentRowWidth: CGFloat = 0
        
        
        let minuteInfoData = departure.minuteInfos?.allObjects as? [MHD_MinuteInfo] ?? []
        let sortedMinuteInfoData = minuteInfoData.sorted { $0.minute < $1.minute }
        
        for (minuteInfoIndex, minuteInfo) in sortedMinuteInfoData.enumerated() {
            if currentRowWidth + availableMinuteViewWidth + itemMargin > availbaleWidth {
                departureMinutesStack.addArrangedSubview(currentRow)
                currentRow = createMinutesInfoRow()
                currentRowWidth = 0
            }
            
            let minuteView = createMinuteView(
                minuteViewIndex: minuteInfoIndex,
                text: formatMinute(minuteInfo),
                width: availableMinuteViewWidth,
                highlightRow: currentTable && (highlightRowIndex == cellIndex),
                highlightMinute: currentTable && (highlightMinuteIndex == minuteInfoIndex)
            )
            currentRow.addArrangedSubview(minuteView)
            if minuteInfoIndex + 1 < sortedMinuteInfoData.count {
                let separator = UILabel(text: "|")
                separator.layer.name = "separator"
                separator.textColor = currentTable && (highlightRowIndex == cellIndex) ? .neutral : .neutral800
                currentRow.addArrangedSubview(separator)
            }
            currentRowWidth += availableMinuteViewWidth
        }
        if !currentRow.arrangedSubviews.isEmpty {
            departureMinutesStack.addArrangedSubview(currentRow)
        }
        
        
        departureMinutesStack.addBorder(for: [.left], in: .neutral800, width: 1)
    }
    
    private func createMinutesInfoRow() -> UIStackView {
        let minutesInfoRow = UIStackView(
            axis: .horizontal,
            spacing: 0,
            alignment: .center,
            distribution: .fill
        )
        
        return minutesInfoRow
    }
    
    private func createMinuteView(
        minuteViewIndex: Int,
        text: String,
        width: CGFloat,
        highlightRow: Bool = false,
        highlightMinute: Bool = false
    ) -> UIView {
        let backgroundColor: UIColor
        let fontColor: UIColor
        
        switch (highlightRow, highlightMinute) {
        case (true, true):
            // Active row, active minute
            backgroundColor = cellIndex.isMultiple(of: 2) ? .neutral30 : .neutral10
            fontColor = .neutral800
            
        case (true, false):
            // Active row, inactive minute
            backgroundColor = .clear
            fontColor = .neutral
            
        default:
            // Inactive row
            backgroundColor = .clear
            fontColor = .neutral800
        }
        
        let minuteView = UIView()
        minuteView.setDimensions(width: Constants.timeCellWidth, height: Constants.cellHeight)
        
        let activeMinuteViewIndicator = UIView(color: backgroundColor)
        activeMinuteViewIndicator.setDimensions(width: Constants.timeCellWidth - 4, height: 40)
        activeMinuteViewIndicator.setCornerRadius(radius: 2)
        
        let minuteLabel = UILabel(
            text: text,
            font: UIFont.interRegular(size: 16),
            textColor: fontColor
        )
        
        minuteView.addSubview(activeMinuteViewIndicator)
        activeMinuteViewIndicator.center()
        
        activeMinuteViewIndicator.addSubview(minuteLabel)
        minuteLabel.center()
        minuteView.layer.name = "minuteView_\(minuteViewIndex)"
        
        return minuteView
    }
}

