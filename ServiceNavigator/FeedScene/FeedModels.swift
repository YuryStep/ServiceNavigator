//
//  FeedModels.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

struct FeedViewRequest {
    let userSelectedItem: IndexPath?
}

struct FeedInteractorResponse {
    let services: [Int] // TODO: Change Int to real Type
}

struct FeedViewModel {
    var services: [FeedCell.DisplayData]
}
