//
//  MainFlowCoordinator.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol MainFlowCoordinatorProtocol: CoordinatorProtocol {
    func showFeedScene()
    func openAppOrWebForService(atLink: String)
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

    func openAppOrWebForService(atLink link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showInvalidLinkAlertIfPossible()
        }
    }

    private func showInvalidLinkAlertIfPossible() {
        if let topViewController = navigationController.topViewController {
            AppAlertMaker.showAlert(from: topViewController, trigger: .invalidServiceURL)
        }
    }
}

extension MainFlowCoordinator: FeedInteractorDelegateProtocol {
    func openService(atLink link: String) {
        openAppOrWebForService(atLink: link)
    }
}
