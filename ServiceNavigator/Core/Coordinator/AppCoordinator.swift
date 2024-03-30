//
//  AppCoordinator.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol AppCoordinatorProtocol: CoordinatorProtocol {
    func performMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    var finishDelegate: CoordinatorProtocolFinishDelegate?

    private var networkService: NetworkServiceProtocol?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func setNetworkService(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func start(_ flow: AppFlow? = nil) {
        switch flow {
        case .mainFlow: performMainFlow()
        case .none: performMainFlow()
        }
    }

    func performMainFlow() {
        guard let networkService else { return }
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: navigationController,
                                                      networkService: networkService)
        childCoordinators.append(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }
}
