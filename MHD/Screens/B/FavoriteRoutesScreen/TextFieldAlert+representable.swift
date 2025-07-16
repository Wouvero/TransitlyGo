//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


struct TextFieldAlert: UIViewRepresentable {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let text: String
    let affirmativeAction: ((String?) -> Void)?
    let dismissiveAction: (() -> Void)?
    
    
    func makeUIView(context: Context) -> TextFieldAlertView {
        let alert = TextFieldAlertView()
        alert.titleText = title
        alert.messageText = message
        alert.textField.text = text
        
        alert.affirmativeAction = {
            self.affirmativeAction?(alert.textField.text)
        }
        
        alert.dismissiveAction = {
            self.dismissiveAction?()
        }
        
        return alert
    }
    
    
    func updateUIView(_ uiView: TextFieldAlertView, context: Context) {
        
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
    
    static func dismantleUIView(_ uiView: TextFieldAlertView, coordinator: ()) {
        uiView.close()
    }
}
