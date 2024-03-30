//
//  FeedPresenter.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol FeedPresenterProtocol {
    func handleWith(_: FeedInteractorResponse)
}

class FeedPresenter {
    private enum Constants {
        static let fixedIconSize = 56
    }

    private weak var feedView: FeedViewProtocol?

    init(feedView: FeedViewProtocol) {
        self.feedView = feedView
    }
}

extension FeedPresenter: FeedPresenterProtocol {
    func handleWith(_ interactorResponse: FeedInteractorResponse) {
        let feedViewModel = getFeedViewModel(from: interactorResponse)
        feedView?.renderUI(with: feedViewModel)
    }

    private func getFeedViewModel(from interactorResponse: FeedInteractorResponse) -> FeedViewModel {
        var cellsDisplayData = [FeedViewController.FeedCellDisplayData]()
        for service in interactorResponse.rawNetworkModel.body.services {
            var cellDisplayData = FeedViewController.FeedCellDisplayData(iconImage: nil,
                                                                         name: service.name,
                                                                         description: service.description)
            if let imageData = service.iconImageData, let iconImage = UIImage(data: imageData) {
                let iconSize = CGSize(width: Constants.fixedIconSize, height: Constants.fixedIconSize)
                cellDisplayData.iconImage = iconImage.renderedTo(iconSize)
            }
            cellsDisplayData.append(cellDisplayData)
        }
        let feedViewModel = FeedViewModel(services: cellsDisplayData)
        return feedViewModel
    }
}
