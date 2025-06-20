//
//
//
// Created by: Patrik Drab on 16/06/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit
import UIKitPro

class MenuPicker<SelectionType: Hashable>: UIView, UITableViewDataSource, UITableViewDelegate {

    var selectedOption: SelectionType {
        didSet {
            guard selectedOption != oldValue else { return }
            
            selectedOptionLabel.text = displayString(for: selectedOption)
            dropdownTableView.reloadData()
            onSelectedOptionChanged?(selectedOption)
        }
    }
    
    var options: [SelectionType] = []
    
    var displayStringProvider: (SelectionType) -> String
    var onSelectedOptionChanged: ((SelectionType) -> Void)?
    
    private var isPickerVisible: Bool = false {
        didSet {
            guard isPickerVisible != oldValue else { return }
            
            
            if isPickerVisible {
                menuDropdownView.isHidden = false
                backgroundOverlay.isHidden = false
                menuDropdownView.transform = CGAffineTransform(translationX: 0, y: -4)
                positionMenu()
            }

            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self else { return }
                self.menuDropdownView.alpha = self.isPickerVisible ? 1 : 0
            } completion: { [weak self] _ in
                guard let self else { return }
                if !self.isPickerVisible {
                    self.menuDropdownView.isHidden = true
                    self.backgroundOverlay.isHidden = true
                }
            }
        }
    }
    
    private let backgroundOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private let menuDropdownView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 8
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isHidden = true
        return view
    }()
    
    private lazy var dropdownTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    let content: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let icon = IconImageView(systemName: "chevron.up.chevron.down", color: .neutral)
    
    let selectedOptionLabel = UILabel(
        font: UIFont.interMedium(size: 16),
        textColor: .neutral,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    
    init(
        selectedOption: SelectionType,
        options: [SelectionType],
        displayStringProvider: @escaping (SelectionType) -> String = { String(describing: $0) },
        frame: CGRect = .zero
    ) {
        self.displayStringProvider = displayStringProvider
        self.selectedOption = selectedOption
        self.options = options
        super.init(frame: frame)
        setupPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window else { return }
        
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        backgroundOverlay.onTapGesture(animate: false) { [weak self] in
            self?.isPickerVisible = false
        }
        window.addSubview(backgroundOverlay)
        
        
        backgroundOverlay.addSubview(menuDropdownView)
        
        menuDropdownView.addSubview(dropdownTableView)
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: menuDropdownView.topAnchor),
            dropdownTableView.bottomAnchor.constraint(equalTo: menuDropdownView.bottomAnchor),
            dropdownTableView.leadingAnchor.constraint(equalTo: menuDropdownView.leadingAnchor),
            dropdownTableView.trailingAnchor.constraint(equalTo: menuDropdownView.trailingAnchor)
        ])
    }
    
   
    private func setupPicker() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
        
        addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
        selectedOptionLabel.text = displayString(for: selectedOption)
        selectedOptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        content.addArrangedSubview(selectedOptionLabel)
        content.addArrangedSubview(UIView())
        content.addArrangedSubview(icon)
        
        
        // Setup tap gesture
        onTapGesture(animate: false) { [weak self] in
            guard let self else { return }
            isPickerVisible.toggle()
        }
    }
    
    private func positionMenu() {
        guard let window else { return }
        
        // Convert our frame to window coordinates
        let pickerFrameInWindow = convert(bounds, to: window)
        
        let optionHeight: CGFloat = 44
        let maxVisibleOptions: CGFloat = 7
        
        
        let totalHeight = max(optionHeight * CGFloat(options.count), optionHeight)
        let maximumVisibleHeight = CGFloat(optionHeight * maxVisibleOptions)
    
        
        let menuHeight = min(totalHeight, maximumVisibleHeight)
        let menuWidth:CGFloat = 250
        
        let menuPositionY = pickerFrameInWindow.maxY + maximumVisibleHeight < window.frame.maxY - 4
            ? pickerFrameInWindow.maxY + 4
            : pickerFrameInWindow.minY - maximumVisibleHeight - 4
        
        menuDropdownView.frame = CGRect(
            x: pickerFrameInWindow.minX,
            y: menuPositionY,
            width: menuWidth,
            height: menuHeight
        )
        
        dropdownTableView.isScrollEnabled = options.count > Int(maxVisibleOptions)
        
        if isPickerVisible {
            menuDropdownView.alpha = 0
        }
    }
    
    func setTintColor(_ color: UIColor) {
        selectedOptionLabel.textColor = color
        icon.setColor(color)
    }
    
    private func displayString(for option: SelectionType) -> String {
        return displayStringProvider(option)
    }

    private func isOptionSelected(_ option: SelectionType) -> Bool {
        // For dates, we need special comparison
        if let date1 = option as? Date, let date2 = selectedOption as? Date {
            return Calendar.current.isDate(date1, inSameDayAs: date2)
        }
        // Default comparison for non-date types
        return option == selectedOption
    }
    
    // MARK: - TableView delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        
        let currentOption = options[indexPath.row]
        let isSelected = isOptionSelected(currentOption)
        
        cell.textLabel?.text = displayString(for: currentOption)
        cell.textLabel?.textColor = .neutral800
        
//        print("Option: \(currentOption) | Selected: \(selectedOption) | IsSelected: \(isSelected)\n")

        cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
        cell.imageView?.tintColor = isSelected ? .neutral800 : .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isPickerVisible = false
        selectedOption = options[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}


