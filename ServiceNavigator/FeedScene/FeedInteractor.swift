//
//  FeedInteractor.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

protocol FeedInteractorProtocol {
    func handle(_: FeedViewRequest)
}

protocol FeedInteractorDelegateProtocol: AnyObject {}

final class FeedInteractor {
    struct State {
        var servicesInfo = ServicesNetworkModel(body: Body(services: [Service]()), status: 200)
    }

    private weak var delegate: FeedInteractorDelegateProtocol?
    private let feedPresenter: FeedPresenterProtocol
    private let networkService: NetworkServiceProtocol
    private var state = State()

    init(networkService: NetworkServiceProtocol,
         feedPresenter: FeedPresenterProtocol,
         delegate: FeedInteractorDelegateProtocol?)
    {
        self.networkService = networkService
        self.feedPresenter = feedPresenter
        self.delegate = delegate
        prepareInitialState()
    }

    private func prepareInitialState() {
        updateCurrentState { [weak self] in
            guard let self else { return }
            let interactorResponse = FeedInteractorResponse(self.state)
            self.feedPresenter.handleWith(interactorResponse)
        }
    }

    private func updateCurrentState(completion: @escaping () -> Void) {
        networkService.fetchServiceInfoWithIconImageData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(info):
                self.state.servicesInfo = info
                completion()
            case let .failure(error):
                print(error) // TODO: Handle Error
            }
        }
    }
}

extension FeedInteractor: FeedInteractorProtocol {
    func handle(_ feedViewRequest: FeedViewRequest) {
        debugPrint(feedViewRequest)
    }
}

private extension FeedInteractorResponse {
    init(_ state: FeedInteractor.State) {
        rawNetworkModel = state.servicesInfo
    }
}
