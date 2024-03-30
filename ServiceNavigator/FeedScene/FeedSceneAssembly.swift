//
//  FeedSceneAssembly.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

enum FeedSceneAssembly {
    static func makeModule(interactorDelegate delegate: FeedInteractorDelegateProtocol?,
                           networkService: NetworkServiceProtocol) -> UIViewController
    {
        let viewController = FeedViewController()
        let presenter = FeedPresenter(feedView: viewController)
        let interactor = FeedInteractor(networkService: networkService, feedPresenter: presenter, delegate: delegate)
        viewController.interactor = interactor
        return viewController
    }
}
