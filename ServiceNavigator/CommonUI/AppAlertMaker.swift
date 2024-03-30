//
//  AppAlertMaker.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

enum AppAlertMaker {
    enum Event {
        case invalidServiceURL

        var title: String {
            switch self {
            case .invalidServiceURL: "Проблема с открытием сервиса"
            }
        }

        var message: String {
            switch self {
            case .invalidServiceURL: "Не удалось открыть URL."
            }
        }

        var okButtonTitle: String {
            switch self {
            case .invalidServiceURL: "ОК"
            }
        }
    }

    static func showAlert(
        from viewController: UIViewController,
        trigger: Event,
        alertStyle: UIAlertController.Style = .alert,
        okActionStyle: UIAlertAction.Style = .default,
        okActionHandler: ((UIAlertAction) -> Void)? = nil,
        animated: Bool = true,
        onCompletion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: trigger.title, message: trigger.message, preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: trigger.okButtonTitle, style: okActionStyle, handler: okActionHandler)
        alert.addAction(okAction)
        viewController.present(alert, animated: animated, completion: onCompletion)
    }
}
