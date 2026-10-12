//
//  AlertModifier.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

extension View {
    @ViewBuilder
    func alert(isPresented: Binding<Bool>, model: AlertModel?) -> some View {
        modifier(AlertModifier(isPresented: isPresented, model: model))
    }
}

struct AlertModel {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let primaryAction: AlertActionModel
    let cancelAction: AlertActionModel
}

struct AlertActionModel {
    let role: ButtonRole?
    let title: LocalizedStringResource
    let action: () -> Void

    init(role: ButtonRole? = nil, title: LocalizedStringResource, action: @escaping () -> Void) {
        self.role = role
        self.title = title
        self.action = action
    }
}

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let model: AlertModel?

    func body(content: Content) -> some View {
        content
            .alert(
                Text(model?.title ?? LocalKey.alertTitle),
                isPresented: $isPresented,
                presenting: model
            ) { model in
                let cancelAction = model.cancelAction
                Button(role: .cancel, action: cancelAction.action) {
                    Text(cancelAction.title)
                }

                let primaryAction = model.primaryAction
                Button(role: primaryAction.role, action: primaryAction.action) {
                    Text(primaryAction.title)
                }
            } message: { model in
                Text(model.message)
            }
    }
}

#if DEBUG
private struct TestAlertView1: View {
    @State private var showAlert = false
    @State private var alertModel: AlertModel?

    var body: some View {
        Button {
            alertModel = model
            showAlert = true
        } label: {
            Image(systemName: "hand.tap")
        }
        .alert(isPresented: $showAlert, model: alertModel)
    }

    private let model: AlertModel = EditorAlert.saveFailure.model {
        print("Try again")
    } cancel: {
        print("Cancel")
    }

}

#Preview {
    TestAlertView1()
}
#endif
