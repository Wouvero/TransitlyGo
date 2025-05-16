//
//
//
// Created by: Patrik Drab on 14/05/2025
// Copyright (c) 2025 MHD 
//
//         


import UIKit
import UIKitTools

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "TableViewCell"
    
    private var cellIndex: Int = 0
    
    private let departureHourView: UIView = {
        let v = UIView()
        v.setDimensions(width: 50, height: 50)
        return v
    }()
    
    private var departureHourLabel = UILabel(
        text: "1",
        font: UIFont.systemFont(ofSize: 16, weight: .bold),
        textColor: .black,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private var rootStackView = UIStackView(
        arrangedSubviews: [],
        axis: .horizontal,
        spacing: 0,
        alignment: .leading,
        distribution: .fill
    )
    
    private let departureMinutesStack = UIStackView(
        arrangedSubviews: [],
        axis: .vertical,
        spacing: 0,
        alignment: .leading,
        distribution: .fill
    )
    
    private var countdownLabel = UILabel(
        text: "",
        font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium),
        textColor: .white,
        textAlignment: .right,
        numberOfLines: 1
    )
    
    private let countdownView = UIView(color: .systemBlue)
    
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
        departureHourLabel.center()
        
        //setup cellContainer
        addSubviews(rootStackView)
        rootStackView.pinToSuperview()
        
        //setup countdownView
        countdownView.setDimensions(width: 100, height: 50)
        countdownView.addSubview(countdownLabel)
        countdownLabel.center()
        countdownView.isHidden = true
        
        //add content into cellContainer
        rootStackView.addArrangedSubview(departureHourView)
        rootStackView.addArrangedSubview(departureMinutesStack)
        rootStackView.addArrangedSubview(countdownView)
        
        
        departureMinutesStack.addBorder(for: [.left], in: .gray, width: 1)
    }
    
    func configure(
        with departure: CDHourlyDeparture,
        cellIndex: Int,
        currentTable: Bool,
        highlightRowIndex: Int? = nil,
        highlightMinuteIndex: Int? = nil,
        timeRemaining: String? = nil
    ) {
        self.cellIndex = cellIndex
        
        
        rootStackView.backgroundColor = currentTable && (highlightRowIndex == cellIndex)
            ? .black
            : cellIndex.isMultiple(of: 2)
                ? .systemGray5
                : .systemGray6
        
        departureHourLabel.text = numberToString(departure.hour)
        departureHourLabel.textColor = currentTable && (highlightRowIndex == cellIndex) ? .white : .black

        countdownLabel.text = timeRemaining
        countdownView.isHidden = timeRemaining == nil
        
        //rootStackView.addBorder(for: [.bottom], in: (highlightRowIndex == cellIndex) ? Colors.primary : .clear, width: 4)
        
        departureMinutesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        let availbaleWidth = UIScreen.main.bounds.width - 50 - 100
        let availableMinuteViewWidth:CGFloat = 50
        
        var currentRow = createMinutesInfoRow()
        var currentRowWidth: CGFloat = 0
        
        
        let minuteInfoData = departure.minutes?.allObjects as? [CDMinuteInfo] ?? []
        let sortedMinuteInfoData = minuteInfoData.sorted { $0.minute < $1.minute }
        
        for (minuteInfoIndex, minuteInfo) in sortedMinuteInfoData.enumerated() {
            if currentRowWidth + availableMinuteViewWidth > availbaleWidth {
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
                separator.textColor = currentTable && (highlightRowIndex == cellIndex) ? .white : .black
                currentRow.addArrangedSubview(separator)
            }
            currentRowWidth += availableMinuteViewWidth
        }
        if !currentRow.arrangedSubviews.isEmpty {
            departureMinutesStack.addArrangedSubview(currentRow)
        }
    }
    
    private func createMinutesInfoRow() -> UIStackView {
        let minutesInfoRow = UIStackView(
            arrangedSubviews: [],
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
            backgroundColor = cellIndex.isMultiple(of: 2) ? .systemGray5 : .systemGray6
            fontColor = .black
            
        case (true, false):
            // Active row, inactive minute
            backgroundColor = .black
            fontColor = .white
            
        default:
            // Inactive row
            backgroundColor = .clear
            fontColor = .black
        }
        
        let minuteView = UIView(color: backgroundColor)
        let minuteLabel = UILabel(
            text: text,
            font: UIFont.systemFont(ofSize: 16, weight: .regular),
            textColor: fontColor
        )
        minuteView.setDimensions(width: 50, height: 50)
        
        minuteView.addSubview(minuteLabel)
        minuteLabel.center()
        minuteView.layer.name = "minuteView_\(minuteViewIndex)"
        
        return minuteView
    }
}

