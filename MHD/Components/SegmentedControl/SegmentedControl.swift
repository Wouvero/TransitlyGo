//
//
//
// Created by: Patrik Drab on 05/06/2025
// Copyright (c) 2025 MHD
//
//

import UIKit

protocol CustomSegmentedControlProtocol: AnyObject {
    func didTapSegment(at index: Int)
}

class CustomSegmentedControl: UIView {
    // MARK: - Variables
    var segmentedControlContent: UIStackView!
    var segmentedViews: [UIView] = []
    var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary500
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var items: [String] = [] {
        didSet{
            numberOfSegments = items.count
            setupView()
        }
    }
    
    var numberOfSegments: Int = 0
    var defaultControlHeight: CGFloat = 50
    
    var selectorViewWidthConstraint: NSLayoutConstraint!
    var selectorViewLeadingConstraint: NSLayoutConstraint!
    var segmentControlHeightConstraint: NSLayoutConstraint!
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            updateSelectorView()
            updateAppearance()
            delegate?.didTapSegment(at: selectedSegmentIndex)
        }
    }
    
    weak var delegate: CustomSegmentedControlProtocol?
    
    // MARK: Init
    init(items: [String] = []) {
        super.init(frame: .zero)
        self.items = items
        self.numberOfSegments = items.count
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Only update constraints if we have valid size
        guard bounds.width > 0, bounds.height > 0 else { return }
        
        updateHeightConstrain()
        updateSelectorView()
    }

}

// MARK: Setup
extension CustomSegmentedControl {
    
    private func setupView() {
        backgroundColor = .neutral10
        
        // Initial segmentControlHeightConstraint
        segmentControlHeightConstraint = heightAnchor.constraint(equalToConstant: defaultControlHeight)
        segmentControlHeightConstraint.priority = .defaultHigh
        segmentControlHeightConstraint.isActive = true
        
        
        createSegmentedViews()
        configureSelectorView()
        configureSegmentedControlContent()
    }
    
    private func createSegmentedViews() {
        // Remove existing segmentViews from superview
        segmentedViews.forEach { $0.removeFromSuperview() }
        segmentedViews = []
        
        for (index, item) in items.enumerated() {
            let segmentView = UIView()
            let segmentLabel = UILabel(
                text: item,
                font: UIFont.interSemibold(size: 12),
                textColor: .neutral800,
                textAlignment: .center,
                numberOfLines: 0
            )
            
            segmentLabel.translatesAutoresizingMaskIntoConstraints = false
            segmentView.addSubview(segmentLabel)
            
            NSLayoutConstraint.activate([
                segmentLabel.topAnchor.constraint(equalTo: segmentView.topAnchor, constant: 10),
                segmentLabel.bottomAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: -10),
                segmentLabel.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor, constant: 10),
                segmentLabel.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor, constant: -10)
            ])
            
            
            segmentView.tag = index
            segmentView.onTapGesture(animate: false) { [weak self] in
                guard let self else { return }
                self.animateSelectorChange(to: index)
            }
            
            segmentedViews.append(segmentView)
        }
    }
    
    private func configureSegmentedControlContent() {
        if segmentedControlContent != nil {
            segmentedControlContent.removeFromSuperview()
        }
        
        segmentedControlContent = UIStackView(arrangedSubviews: segmentedViews)
        segmentedControlContent.axis = .horizontal
        segmentedControlContent.spacing = 0
        segmentedControlContent.alignment = .fill
        segmentedControlContent.distribution = .fillEqually
        segmentedControlContent.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(segmentedControlContent)
        
        NSLayoutConstraint.activate([
            segmentedControlContent.topAnchor.constraint(equalTo: topAnchor),
            segmentedControlContent.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentedControlContent.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControlContent.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureSelectorView() {
        addSubviews(selectorView)
        
        selectorViewWidthConstraint = selectorView.widthAnchor.constraint(equalToConstant: 0)
        selectorViewWidthConstraint.priority = .defaultHigh
        selectorViewWidthConstraint.isActive = true
        
        selectorViewLeadingConstraint = selectorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        selectorViewLeadingConstraint.priority = .defaultHigh
        selectorViewLeadingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            selectorView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            selectorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    private func updateHeightConstrain() {
        let segmentControlContentHeight = segmentedControlContent.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        ).height
        let actualSegmentControlContentHeight = segmentControlHeightConstraint.constant
        
        if segmentControlContentHeight != actualSegmentControlContentHeight && segmentControlContentHeight > 0 {
            segmentControlHeightConstraint.constant = segmentControlContentHeight
            layoutIfNeeded()
        }
    }
    
    private func updateSelectorView() {
        guard selectedSegmentIndex < segmentedViews.count,
              !segmentedViews.isEmpty,
              bounds.width > 0 else {
            selectorView.isHidden = true
            return
        }
        
        selectorView.isHidden = false
        let item = segmentedViews[selectedSegmentIndex]
        let itemWidth = item.frame.width
        let selectorWidth = max(itemWidth - 10, 1)
        
        selectorViewLeadingConstraint.constant = item.frame.origin.x + 5
        selectorViewWidthConstraint.constant = selectorWidth
        
        NSLayoutConstraint.activate([
            selectorViewLeadingConstraint,
            selectorViewWidthConstraint
        ])
    }
    
}


// MARK: Animate
extension CustomSegmentedControl {
    
    
    private func updateAppearance() {
        for (index, item) in segmentedViews.enumerated() {
            let view = item as UIView
            guard let label = view.subviews.first as? UILabel else { return }
            label.textColor = index == selectedSegmentIndex ? .neutral : .neutral800
        }
    }
    private func animateSelectorChange(to index: Int) {
        selectedSegmentIndex = index

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            self.updateAppearance()
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Utilities
extension CustomSegmentedControl {
    
    func titleForSegment(at index: Int) -> String? {
        guard items.indices.contains(index) else {
            return nil
        }
        return items[index]
    }
    
    func findFirstSegmentIndex(withTitle title: String) -> Int? {
        return items.firstIndex { $0 == title }
    }
    
}
