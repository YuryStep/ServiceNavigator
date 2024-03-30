//
//  UIView+Extensions.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
