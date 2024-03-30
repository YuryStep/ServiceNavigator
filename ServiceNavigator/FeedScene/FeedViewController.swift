//
//  FeedViewController.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {}

final class FeedViewController: UIViewController {
    struct DisplayData {
        let feedCellDisplayData: [FeedCell.DisplayData]
    }

    var interactor: FeedInteractorProtocol?
    private var displayData: DisplayData = .init(feedCellDisplayData: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

extension FeedViewController: FeedViewProtocol {}
