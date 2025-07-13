//
//
//
// Created by: Patrik Drab on 13/07/2025
// Copyright (c) 2025 MHD 
//
//         

import SwiftUI


extension View {
    func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        text: String,
        affirmativeAction: @escaping (String?) -> Void,
        dismissiveAction: @escaping () -> Void
    ) -> some View {
        self.background(
            TextFieldAlert(
                isPresented: isPresented,
                title: title,
                message: message,
                text: text,
                affirmativeAction: affirmativeAction,
                dismissiveAction: dismissiveAction
            )
        )
    }
    
    func systemAlert(
        isPresented: Binding<Bool>,
        title: String?,
        message: String,
        affirmativeAction: @escaping () -> Void,
        dismissiveAction: @escaping () -> Void
    ) -> some View {
        self.background(
            SystemAlert(
                isPresented: isPresented,
                title: title,
                message: message,
                affirmativeAction: affirmativeAction,
                dismissiveAction: dismissiveAction
            )
        )
    }
}
