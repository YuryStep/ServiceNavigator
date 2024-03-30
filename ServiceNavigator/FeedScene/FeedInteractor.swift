//
//  FeedInteractor.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

protocol FeedInteractorProtocol {}

protocol FeedInteractorDelegateProtocol: AnyObject {}

final class FeedInteractor {
    var networkService: NetworkServiceProtocol
    var feedPresenter: FeedPresenterProtocol
    weak var delegate: FeedInteractorDelegateProtocol?

    init(networkService: NetworkServiceProtocol,
         feedPresenter: FeedPresenterProtocol,
         delegate: FeedInteractorDelegateProtocol?)
    {
        self.networkService = networkService
        self.feedPresenter = feedPresenter
        self.delegate = delegate
        testNetworkService(networkService)
    }

    // TODO: Delete
    private func testNetworkService(_ networkService: NetworkServiceProtocol) {
        networkService.fetchServiceInfoWithIconImageData { result in
            switch result {

            case let .success(info):
                print(info.body.services[2])
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension FeedInteractor: FeedInteractorProtocol {}
