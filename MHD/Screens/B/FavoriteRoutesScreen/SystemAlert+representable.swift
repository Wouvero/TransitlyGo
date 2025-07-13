//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


struct SystemAlert: UIViewRepresentable {
    @Binding var isPresented: Bool
    
    let title: String?
    let message: String?
    let affirmativeAction: (() -> Void)?
    let dismissiveAction: (() -> Void)?
    
    
    func makeUIView(context: Context) -> SystemAlertView {
        let alert = SystemAlertView()
        alert.titleText = title
        alert.messageText = message
        
        alert.affirmativeButton.setButtonLabelText("Vymazať")
        alert.affirmativeButton.setBackground(.danger700)
        alert.affirmativeAction = {
            self.affirmativeAction?()
        }
        
        alert.dismissiveAction = {
            self.dismissiveAction?()
        }
        
        return alert
    }
    
    func updateUIView(_ uiView: SystemAlertView, context: Context) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            uiView.close()
            return
        }
        
        if isPresented {
            uiView.show(on: window)
        } else {
            uiView.close()
        }
    }
    
    static func dismantleUIView(_ uiView: SystemAlertView, coordinator: ()) {
        uiView.close()
    }
}
