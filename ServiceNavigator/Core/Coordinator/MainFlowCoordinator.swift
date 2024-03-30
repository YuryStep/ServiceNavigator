//
//  MainFlowCoordinator.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol MainFlowCoordinatorProtocol: CoordinatorProtocol {
    func showFeedScene()
    func showWebSwitchScene()
}

final class MainFlowCoordinator: MainFlowCoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    var finishDelegate: CoordinatorProtocolFinishDelegate?
    private var networkService: NetworkServiceProtocol

    init(navigationController: UINavigationController, networkService: NetworkServiceProtocol) {
        self.navigationController = navigationController
        self.networkService = networkService
    }

    func start(_: AppFlow? = nil) {
        showFeedScene()
    }

    func showFeedScene() {
        let viewController = FeedSceneAssembly.makeModule(interactorDelegate: self, networkService: networkService)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showWebSwitchScene() {
        print("showWebSwitchScene action is not implemented")
    }
}

extension MainFlowCoordinator: FeedInteractorDelegateProtocol {}
