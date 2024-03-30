//
//  FeedPresenter.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

protocol FeedPresenterProtocol {}

class FeedPresenter {
    private weak var feedView: FeedViewProtocol?

    init(feedView: FeedViewProtocol) {
        self.feedView = feedView
    }
}

extension FeedPresenter: FeedPresenterProtocol {}
