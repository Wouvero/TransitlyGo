//
//
//
// Created by: Patrik Drab on 16/05/2025
// Copyright (c) 2025 MHD 
//
//         

import UIKit

extension Notification.Name {
    static let didSelectStation = Notification.Name("didSelectStation")
}

struct NotificationKey {
    static let station: String = "Station"
    static let inputFieldType: String = "InputFieldType"
}


enum InputFieldType: String {
    case from = "Zo zastávky"
    case to = "Na zastávku"
}

class SearchRouteViewModel {
    // UI State
    var isOptionsExpanded: Bool = false {
        didSet {
            guard isOptionsExpanded != oldValue else { return }
            if !isOptionsExpanded {
                selectedDate = Date()
                getCurentTime()
            }
            onIsOptionsExpandedChanged?(isOptionsExpanded)
        }
    }
    
    // Input fields
    var fromInputText: String = "" {
        didSet {
            guard fromInputText != oldValue else { return }
            onFromInputChanged?(fromInputText)
        }
    }
    var toInputText: String = "" {
        didSet {
            guard toInputText != oldValue else { return }
            onToInputChanged?(toInputText)
        }
    }
    
    // Time selection
    var hour: String = ""
    var minute: String = ""
    var selectedDate: Date = Date() {
        didSet {
            guard selectedDate != oldValue else { return }
            onSelectedDateChanged?(selectedDate)
        }
    }
    var dateOptions: [Date] = []
    
    // Callbacks
    var onFromInputChanged:         ((String) -> Void)?
    var onToInputChanged:           ((String) -> Void)?
    var onIsOptionsExpandedChanged: ((Bool) -> Void)?
    var onHourChanged:              ((String) -> Void)?
    var onMinuteChanged:            ((String) -> Void)?
    var onSelectedDateChanged:      ((Date) -> Void)?
    
    
    // Dependencies
    private var router: UINavigationController
    
    init(router: UINavigationController) {
        self.router = router
        self.dateOptions = generateDateOptions()
        getCurentTime()
        setupObserver()
    }
    
    func switchInputs() {
        guard !fromInputText.isEmpty || !toInputText.isEmpty else { return }
        swap(&fromInputText, &toInputText)
    }
    
    func showExtendedOptions() {
        isOptionsExpanded.toggle()
    }
    
    func search() {
        guard !fromInputText.isEmpty else {
            print("Missing fromInputText")
            return
        }
        
        guard !toInputText.isEmpty else {
            print("Missing toInputText")
            return
        }
        
        
        
        print("-----------------------------")
        print("Zo zastavky: ",fromInputText)
        print("Na zastavku: ",toInputText)
        
        print("Den: ", formatDate(selectedDate))
        print("Hodina: ", hour)
        print("Minuta: ", minute)
        print("-----------------------------")
    }
    
}

extension SearchRouteViewModel {
    
    func handleTap(for fieldType: InputFieldType = .from) {
        presentSearchController(for: fieldType)
    }
    
    private func presentSearchController(for fieldType: InputFieldType = .from) {
        let searchController = DestinationSearchViewController()
        searchController.fieldType = fieldType
        router.pushViewController(searchController, animated: true)
    }
    
}

extension SearchRouteViewModel {
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didSelectStation),
            name: .didSelectStation,
            object: nil
        )
    }
    
    @objc private func didSelectStation(_ notification: Notification) {
        if let stationInfo = notification.object as? MHD_StationInfo,
           let userInfo = notification.userInfo,
           let textFieldType = userInfo["fieldType"] as? InputFieldType {
            switch textFieldType {
            case .from:
                fromInputText = stationInfo.stationName ?? ""
            case .to:
                toInputText = stationInfo.stationName ?? ""
            }
        }
    }
}

extension SearchRouteViewModel {
    // Generate options for current day + next 7 days
    private func generateDateOptions() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<8).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today)
        }
    }
    
    private func getCurentTime() {
        let calendar = Calendar.current
        let today = Date()
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: today)
        guard let curentHour = dateComponents.hour,
              let currentMinute = dateComponents.minute else { return }
        
        print(curentHour)
        print(currentMinute)
        
        hour = String(curentHour)
        minute = String(currentMinute)
    }
}




class RouteSelectionViewController: UIViewController, MHD_NavigationDelegate {
    // MARK: - Navigation variables
    var contentLabelText: NSAttributedString {
        return NSAttributedStringBuilder()
            .add(text: "Vyhľadanie spojenia", attributes: [.font: UIFont.interSemibold(size: 16)])
            .build()
    }
    
    lazy var searchRouteVM: SearchRouteViewModel = {
        guard let navController = navigationController else {
            fatalError("NavigationController is not available")
        }
        return SearchRouteViewModel(router: navController)
    }()
    
    // MARK: - Variables
    private let fromInputTextField: CustomInactiveTextField = {
        let tf = CustomInactiveTextField()
        tf.setupPlaceholder(InputFieldType.from.rawValue)
        return tf
    }()
    
    private let toInputTextField: CustomInactiveTextField = {
        let tf = CustomInactiveTextField()
        tf.setupPlaceholder(InputFieldType.to.rawValue)
        return tf
    }()
    
    private let hourTextField: CustomTimeTextField = {
        let tf = CustomTimeTextField(type: .hour)
        tf.setDimensions(width: 60, height: 50)
        tf.setupPlaceholder("Hod.")
        return tf
    }()
    
    private let minuteTextField: CustomTimeTextField = {
        let tf = CustomTimeTextField(type: .minute)
        tf.setDimensions(width: 60, height: 50)
        tf.setupPlaceholder("Min.")
        return tf
    }()
    
    let doubleDotLabel = UILabel(
        text: ":",
        font: UIFont.interRegular(size: 16),
        textColor: .neutral800,
        textAlignment: .center,
        numberOfLines: 1
    )
    
    private var optionPicker: MenuPicker<Date>!
    
    private let changeButton = CustomButton(
        type: .iconOnly(
            iconName: SFSymbols.changePosition,
            iconColor: .neutral,
            iconSize: 24
        ),
        style: .filled(
            backgroundColor: .neutral800,
            cornerRadius: 8
        ),
        size: .custom(width: 44, height: 44)
    )
    
    private let searchButton = CustomButton(
        type: .textOnly(
            label: "Vyhľadať",
            textColor: .neutral
        ),
        style: .filled(
            backgroundColor: .primary500,
            cornerRadius: 8
        ),
        size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
    )
    
    private let expandButton = CustomButton(
        type: .textOnly(
            label: "Viac",
            textColor: .neutral800
        ),
        style: .plain(cornerRadius: 8),
        size: .auto(pTop: 16, pTrailing: 16, pBottom: 16, pLeading: 16)
    )
    
    private let expandContentView = UIStackView(
        axis: .vertical,
        spacing: 8
    )
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutral10
        
        setupUI()
        setupViewModelBinding()
        setupTimeTextFields()
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(false)
    }
    
    private func setupViewModelBinding() {
        searchRouteVM.onFromInputChanged = { [weak self] newValue in
            guard let self = self else { return }
            fromInputTextField.text = newValue
        }
        
        searchRouteVM.onToInputChanged = { [weak self] newValue in
            guard let self = self else { return }
            toInputTextField.text = newValue
        }
        
        searchRouteVM.onIsOptionsExpandedChanged = { [weak self] newState in
            guard let self = self else { return }
            expandContentView.isHidden = !newState
            expandButton.setButtonLabelText(newState ? "Menej" : "Viac")
            if newState == false {
                view.endEditing(true)
            }
        }
        
        searchRouteVM.onSelectedDateChanged = { [weak self] newValue in
            guard let self = self else { return }
            optionPicker.selectedOption = newValue
        }
        
        searchRouteVM.onHourChanged = { [weak self] newValue in
            guard let self = self else { return }
            hourTextField.text = newValue
        }
        
        searchRouteVM.onMinuteChanged = { [weak self] newValue in
            guard let self = self else { return }
            minuteTextField.text = newValue
        }
    }
    
    private func setupTimeTextFields() {
        hourTextField.onTextChanged = { [weak self] changedText in
            guard let self = self else { return }
            searchRouteVM.hour = changedText
        }
        
        minuteTextField.onTextChanged = { [weak self] changedText in
            guard let self = self else { return }
            searchRouteVM.minute = changedText
        }
    }
        
}


// MARK: - Setup UI
extension RouteSelectionViewController {
    
    private func setupFromInputTextField() {
        fromInputTextField.onTapGesture { [weak self] in
            guard let self = self else { return }
            searchRouteVM.handleTap(for: .from)
        }
    }
    
    private func setupToInputTextField() {
        toInputTextField.onTapGesture {[weak self] in
            guard let self = self else { return }
            searchRouteVM.handleTap(for: .to)
        }
    }
    
    private func setupSearchButton() {
        searchButton.onRelease = { [weak self] in
            guard let self = self else { return }
            searchRouteVM.search()
        }
    }
    
    private func setupChangeButton() {
        changeButton.onTapGesture { [weak self] in
            guard let self = self else { return }
            searchRouteVM.switchInputs()
        }
    }
    
    private func setupExpandButton() {
        expandButton.onTapGesture { [weak self] in
            guard let self = self else { return }
            searchRouteVM.showExtendedOptions()
        }
    }
    
    private func setupOptionPicker() {
        optionPicker = MenuPicker(
            selectedOption: searchRouteVM.selectedDate,
            options: searchRouteVM.dateOptions) { formatDate($0) }
        
        optionPicker.onSelectedOptionChanged = { [weak self] newValue in
            guard let self else { return }
            searchRouteVM.selectedDate = newValue
        }
        
        optionPicker.backgroundColor = .clear
        optionPicker.layer.borderColor = UIColor.neutral200.cgColor
        optionPicker.layer.borderWidth = 1
        optionPicker.setTintColor(UIColor.neutral800)
    }
    
    private func setupContent() {
        // Setup search inputs stack
        let searchInputsStack = UIStackView(
            arrangedSubviews: [
                fromInputTextField,
                toInputTextField
            ],
            spacing: 8
        )
        
        searchInputsStack.addSubview(changeButton)
        changeButton.trailing(offset: .init(x: -20, y: 0))
        
        hourTextField.text = searchRouteVM.hour
        minuteTextField.text = searchRouteVM.minute

        let timeStackView = UIStackView(
            arrangedSubviews: [
                hourTextField,
                doubleDotLabel,
                minuteTextField,
                UIView()
            ],
            axis: .horizontal,
            spacing: 8,
            alignment: .center,
            distribution: .fill
            
        )
        
        expandContentView.addArrangedSubview(optionPicker)
        expandContentView.addArrangedSubview(timeStackView)
        expandContentView.isHidden = true
        
        // Setup root stack
        let rootStackView = UIStackView(
            arrangedSubviews: [
                searchInputsStack,
                expandContentView,
                searchButton,
                expandButton
            ],
            spacing: 8
        )
        rootStackView.setCustomSpacing(16, after: searchInputsStack)
        rootStackView.setCustomSpacing(16, after: expandContentView)
        
        view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalPadding),
            rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalPadding),
            rootStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        setupFromInputTextField()
        setupToInputTextField()
        setupSearchButton()
        setupChangeButton()
        setupExpandButton()
        setupOptionPicker()
        setupContent()
    }
    
}
