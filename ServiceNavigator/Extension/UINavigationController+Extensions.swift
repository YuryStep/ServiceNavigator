//
//  UINavigationController+Extensions.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

extension UINavigationController {
    func setupDefaultNavigationBarAppearance() {
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
