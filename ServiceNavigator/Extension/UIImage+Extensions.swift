//
//  UIImage+Extensions.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

extension UIImage {
    func renderedTo(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }
}
