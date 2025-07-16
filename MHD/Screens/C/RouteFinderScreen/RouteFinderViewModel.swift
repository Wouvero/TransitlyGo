//
//
//
// Created by: Patrik Drab on 22/06/2025
// Copyright (c) 2025 MHD 
//
//

import UIKit
import SwiftUI

extension Notification.Name {
    static let didSelectStation = Notification.Name("didSelectStation")
}

struct NotificationKey {
    static let station: String = "Station"
    static let inputFieldType: String = "InputFieldType"
}

struct StationSelectionNotification {
    let station: MHD_StationInfo
    let inputFieldType: InputFieldType
    
    init?(notification: Notification) {
        guard let station = notification.object as? MHD_StationInfo,
              let inputFieldType = notification.userInfo?["fieldType"] as? InputFieldType else { return nil }
        
        self.station = station
        self.inputFieldType = inputFieldType
    }
}

// MARK: Model
struct RouteFinderModel {
    let fromStationInfo: MHD_StationInfo
    let toStationInfo: MHD_StationInfo
    let hour: String
    let minute: String
    let selectedDay: Date
    
    var formattedTime: String {
        let hourInt = Int(hour) ?? 0
        let minuteInt = Int(minute) ?? 0
        return String(format: "%02d:%02d", hourInt, minuteInt)
    }
    
    var formattedSelectedDay: String {
        formatDate(selectedDay)
    }
}


enum InputFieldType: String {
    case from = "Zo zastávky"
    case to = "Na zastávku"
}

// MARK: - ViewModel
class RouteFinderViewModel {
    // Properties
    private let calendar = Calendar.current
    private var router: UINavigationController
    
    // UI State
    var isOptionsExpanded: Bool = false {
        didSet {
            guard isOptionsExpanded != oldValue else { return }
            handleOptionsExpansionChange()
        }
    }
    
    // Input fields
    var fromStationInfo: MHD_StationInfo? {
        didSet {
            guard fromStationInfo != oldValue else { return }
            onFromInputChanged?(fromStationInfo?.stationName ?? "")
        }
    }
    var toStationInfo: MHD_StationInfo? {
        didSet {
            guard toStationInfo != oldValue else { return }
            onToInputChanged?(toStationInfo?.stationName ?? "")
        }
    }
    
    // Time selection
    var hour: String = ""
    var minute: String = ""
    var selectedDay: Date = Date() {
        didSet {
            guard selectedDay != oldValue else { return }
            onSelectedDayChanged?(selectedDay)
        }
    }
    lazy var dateOptions: [Date] = generateDateOptions()
    
    
    // Callbacks
    var onFromInputChanged:         ((String) -> Void)?
    var onToInputChanged:           ((String) -> Void)?
    var onIsOptionsExpandedChanged: ((Bool) -> Void)?
    var onHourChanged:              ((String) -> Void)?
    var onMinuteChanged:            ((String) -> Void)?
    var onSelectedDayChanged:       ((Date) -> Void)?
    
    
    init(router: UINavigationController) {
        self.router = router
        resetToCurrentTime()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func switchInputs() {
        (fromStationInfo, toStationInfo) = (toStationInfo, fromStationInfo)
    }
    
    func showExtendedOptions() {
        isOptionsExpanded.toggle()
    }
    
    func search() {
        guard let fromStationInfo, let toStationInfo else {
            showMissingInputsAlert()
            return
        }
        
        guard fromStationInfo != toStationInfo else {
            showNotASameInputsAlert()
            return
        }
        
        let searchRouteModel = RouteFinderModel(
            fromStationInfo: fromStationInfo,
            toStationInfo: toStationInfo,
            hour: hour,
            minute: minute,
            selectedDay: selectedDay
        )
        
        let vc = ResultScreenViewController(searchRouteModel: searchRouteModel)
        router.pushViewController(vc, animated: true)
    }
    
    private func showMissingInputsAlert() {
        let alert = SystemAlertView()
        alert.titleText = "Chýbajúce údaje"
        alert.messageText = "Polia 'Zo zastavky' a 'Na zastávku' musia byť vyplnené."
        alert.buttonConfig = .primaryOnly
        alert.affirmativeAction = {
            alert.close()
        }
        alert.show(on: router)
    }
    
    private func showNotASameInputsAlert() {
        let alert = SystemAlertView()
        alert.titleText = "Neplatné údaje"
        alert.messageText = "Polia 'Zo zastavky' a 'Na zastávku' nemôžu mať rovnakú hodnotu."
        alert.buttonConfig = .primaryOnly
        alert.affirmativeAction = {
            alert.close()
        }
        alert.show(on: router)
    }
    
    private func presentSwiftUIAlert(_ alertView: some View) {
        let hostingController = UIHostingController(rootView: alertView)
        hostingController.modalPresentationStyle = .fullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Ensure we're on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.router.present(hostingController, animated: true)
        }
    }
}


extension RouteFinderViewModel {
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: .didSelectStation,
            object: nil,
            queue: .main) { [weak self] notification in
                guard let selection = StationSelectionNotification(notification: notification) else { return }
                self?.updateStation(selection.station, for: selection.inputFieldType)
            }
    }
    
    private func updateStation(_ station: MHD_StationInfo, for fieldType: InputFieldType) {
        switch fieldType {
        case .from: fromStationInfo = station
        case .to: toStationInfo = station
        }
    }
    
}

extension RouteFinderViewModel {
    // Generate options for current day + next 7 days
    private func generateDateOptions() -> [Date] {
        return (0..<8).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: Date())
        }
    }
    
    func resetToCurrentTime() {
        let today = Date()
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: today)
        
        guard let currentHour = dateComponents.hour,
              let currentMinute = dateComponents.minute else { return }
        
        let newHour = String(currentHour)
        let newMinute = String(currentMinute)
           
        guard hour != newHour || minute != newMinute else { return }
        
        hour = newHour
        minute = newMinute
    }
}

extension RouteFinderViewModel {
    
    private func handleOptionsExpansionChange() {
        if !isOptionsExpanded {
            selectedDay = Date()
            resetToCurrentTime()
        }
        onIsOptionsExpandedChanged?(isOptionsExpanded)
    }
}
