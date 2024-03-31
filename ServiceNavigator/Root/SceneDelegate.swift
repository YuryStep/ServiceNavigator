//
//  SceneDelegate.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appCoordinator = AppCoordinator(navigationController: UINavigationController())

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        configureAppInitialState(with: scene)
        appCoordinator.start()
    }

    private func configureAppInitialState(with scene: UIWindowScene) {
        let rootNavigationController = UINavigationController()
        rootNavigationController.setupDefaultNavigationBarAppearance()

        window = UIWindow(windowScene: scene)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        let networkService = NetworkService()
        configureAppCoordinatorWith(rootNavigationController, networkService: networkService)
    }

    private func configureAppCoordinatorWith(_ navigationController: UINavigationController,
                                             networkService: NetworkServiceProtocol)
    {
        appCoordinator.navigationController = navigationController
        appCoordinator.setNetworkService(networkService)
    }
}
