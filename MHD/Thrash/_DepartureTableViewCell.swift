//
//
//
// Created by: Patrik Drab on 03/05/2025
// Copyright (c) 2025 MHD
//
//


import UIKit


class DepartureTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DepartureTableViewCell"
    
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
        
        //add content into cellContainer
        rootStackView.addArrangedSubview(departureHourView)
        rootStackView.addArrangedSubview(departureMinutesStack)
        
        departureMinutesStack.addBorder(for: [.left], in: .gray, width: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func configure(
        with departure: CDHourlyInfo,
        departureCellIndex: Int,
        activeHourIndex: Int?,
        activeMinuteIndex: Int?
    ) {
        cellIndex = departureCellIndex
        
        rootStackView.backgroundColor = (activeHourIndex == departureCellIndex)
            ? .black
            : departureCellIndex.isMultiple(of: 2)
                ? .systemGray5
                : .systemGray6
        
        rootStackView.addBorder(for: [.bottom], in: activeHourIndex == departureCellIndex ? Colors.primary : .clear, width: 4)
        
//        //resetAllMinuteViews()
//       
//        // find a way how to arase border from rootstack view
//        rootStackView.addBorder(for: [.bottom], in: .black, width: 0)
//        
        
        departureHourLabel.text = numberToString(departure.hour)
        departureHourLabel.textColor = (activeHourIndex == departureCellIndex) ? .white : .black
        
        departureMinutesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        let availbaleWidth = UIScreen.main.bounds.width - 50
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
                highlightRow: (activeHourIndex == departureCellIndex),
                highlightMinute: (activeMinuteIndex == minuteInfoIndex)
            )
            currentRow.addArrangedSubview(minuteView)
            if minuteInfoIndex + 1 < sortedMinuteInfoData.count {
                let separator = UILabel(text: "|")
                separator.layer.name = "separator"
                separator.textColor = (activeHourIndex == departureCellIndex) ? .white : .black
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
    
    
    
//    func updateAppearance(activeMinuteIndex: Int?) {
////        rootStackView.backgroundColor = .gray
////        rootStackView.addBorder(for: [.bottom], in: Colors.primary, width: 4)
////        
////        departureHourLabel.textColor = .white
////        
////        resetAllMinuteViews()
////        
////        guard let activeIndex = activeMinuteIndex else { return }
////            
////        findAndHighlightMinuteView(index: activeIndex)
//    }
    
//    private func resetAllRowStackViews() {
//        departureMinutesStack.arrangedSubviews.enumerated().forEach { (index, rowStack) in
//            (rowStack as? UIStackView)?.backgroundColor = index.isMultiple(of: 2) ? .systemGray5 : .systemGray6
//            
//        }
//    }
    
//    private func resetAllMinuteViews() {
//        departureMinutesStack.arrangedSubviews.forEach { rowStack in
//            (rowStack as? UIStackView)?.arrangedSubviews.forEach { minuteView in
//                minuteView.backgroundColor = .clear
//                minuteView.subviews.forEach {
//                    ($0 as? UILabel)?.textColor = .black
//                }
//            }
//        }
//    }
//    
//    private func findAndHighlightMinuteView(index: Int) {
//        let targetName = "minuteView_\(index)"
//        
//        //resetAllMinuteViews()
//        
//        for case let rowStack as UIStackView in departureMinutesStack.arrangedSubviews {
//            if let minuteView = rowStack.arrangedSubviews.first(where: {
//                $0.layer.name == targetName
//            }) {
//                minuteView.backgroundColor = index.isMultiple(of: 2) ? .systemGray5 : .systemGray6
//                minuteView.subviews.forEach {
//                    ($0 as? UILabel)?.textColor = .black
//                }
//                return
//            }
//        }
//    }
}

