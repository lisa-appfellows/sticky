//
//  FailedOperationAlert.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-09.
//

import SwiftUI

extension View {
    func failedOperationAlert(
        isPresented: Binding<Bool>,
        title: LocalizedStringResource,
        retryAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) -> some View {
        modifier(FailedOperationAlertModifier(
            isPresented: isPresented,
            title: title,
            retryAction: retryAction,
            cancelAction: cancelAction
        ))
    }
}

struct FailedOperationAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: LocalizedStringResource
    let retryAction: () -> Void
    let cancelAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(Text(title), isPresented: $isPresented) {
                Button(role: .cancel, action: cancelAction) {
                    Text(LocalKey.cancel)
                }
                Button(action: retryAction) {
                    Text(LocalKey.tryAgain)
                }
            } message: {
                Text(LocalKey.alertMessage)
            }
    }
}

#if DEBUG
private struct TestAlertView: View {
    @State private var showAlert = false

    var body: some View {
        Button {
            showAlert = true
        } label: {
            Text("Show Alert")
        }
        .failedOperationAlert(
            isPresented: $showAlert,
            title: LocalKey.operationFailedTitle,
            retryAction: {},
            cancelAction: {}
        )
    }
}

#Preview {
    TestAlertView()
}
#endif
