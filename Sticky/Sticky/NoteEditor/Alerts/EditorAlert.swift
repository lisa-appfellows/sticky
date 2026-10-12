//
//  EditorAlert.swift
//  Sticky
//
//  Created by Lisa Fellows on 2026-10-11.
//

import Foundation

enum EditorAlert {
    case saveFailure
    case deleteConfirmation
    case deleteFailure

    var title: LocalizedStringResource {
        switch self {
        case .saveFailure: return LocalKey.saveAlertTitle
        case .deleteConfirmation: return LocalKey.deleteConfirmationAlertTitle
        case .deleteFailure: return LocalKey.deleteAlertTitle
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .deleteConfirmation: return LocalKey.deleteConfirmationAlertMessage
        default: return LocalKey.failedOperationAlertMessage
        }
    }

    var primaryActionTitle: LocalizedStringResource {
        switch self {
        case .deleteConfirmation: return LocalKey.confirm
        default: return LocalKey.tryAgain
        }
    }

    var cancelActionTitle: LocalizedStringResource {
        LocalKey.cancel
    }

    func model(primary: @escaping () -> Void, cancel: @escaping () -> Void) -> AlertModel {
        .init(
            title: title,
            message: message,
            primaryAction: .init(
                role: self == .deleteConfirmation ? .destructive : nil,
                title: primaryActionTitle, action: primary
            ),
            cancelAction: .init(title: cancelActionTitle, action: cancel))
    }
}
