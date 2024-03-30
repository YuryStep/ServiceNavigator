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
    let rawNetworkModel: ServicesNetworkModel
}

struct FeedViewModel {
    var services: [FeedViewController.FeedCellDisplayData]
}
