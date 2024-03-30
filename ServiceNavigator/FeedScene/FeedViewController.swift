//
//  FeedViewController.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import UIKit

protocol FeedViewProtocol: AnyObject {
    func renderUI(with: FeedViewModel)
}

final class FeedViewController: UIViewController {
    typealias FeedCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    struct FeedCellDisplayData: Hashable {
        let id = UUID()
        var iconImage: UIImage?
        let name: String
        let description: String
    }

    struct DisplayData {
        var feedCellDisplayData: [FeedCellDisplayData]
    }

    enum Section {
        case main
    }

    enum Item: Hashable {
        case service(FeedCellDisplayData)
    }

    var interactor: FeedInteractorProtocol?
    private var displayData = DisplayData(feedCellDisplayData: [])

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        activityIndicator.style = .large
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        configureDataSource()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Сервисы"
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubviews([collectionView, loadingIndicator])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        var separatorConfiguration = UIListSeparatorConfiguration(listAppearance: .plain)
        separatorConfiguration.color = .systemGray
        separatorConfiguration.topSeparatorVisibility = .hidden

        var collectionConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionConfiguration.backgroundColor = .clear
        collectionConfiguration.separatorConfiguration = separatorConfiguration
        return UICollectionViewCompositionalLayout.list(using: collectionConfiguration)
    }

    private func configureDataSource() {
        let cellRegistration = FeedCellRegistration { cell, _, item in
            switch item {
            case let .service(feedCellDisplayData):
                self.configureCell(cell, with: feedCellDisplayData)
            }
        }

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, identifier -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }

    private func configureCell(_ cell: UICollectionViewListCell, with displayData: FeedCellDisplayData) {
        var content = cell.defaultContentConfiguration()
        content.text = displayData.name
        content.textProperties.color = .white
        content.secondaryText = displayData.description
        content.secondaryTextProperties.color = .white
        content.image = displayData.iconImage
        cell.contentConfiguration = content

        cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = .systemGray2

        let disclosureIndicator = UICellAccessory.disclosureIndicator(displayed: .always, options: .init(tintColor: .systemGray))
        cell.accessories = [disclosureIndicator]
    }

    private func applySnapshot(animatingDifferences: Bool) {
        var snapshot = Snapshot()
        let itemsForMainSection = getItemsForMainSection()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemsForMainSection, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func getItemsForMainSection() -> [FeedViewController.Item] {
        var items: [FeedViewController.Item] = []
        for displayData in displayData.feedCellDisplayData {
            let serviceItem = FeedViewController.Item.service(displayData)
            items.append(serviceItem)
        }
        return items
    }
}

extension FeedViewController: FeedViewProtocol {
    func renderUI(with model: FeedViewModel) {
        updateCurrentDisplayDataState(with: model)
        applySnapshot(animatingDifferences: false)
        loadingIndicator.stopAnimating()
    }

    private func updateCurrentDisplayDataState(with model: FeedViewModel) {
        displayData.feedCellDisplayData = model.services
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let request = FeedViewRequest(userSelectedItem: indexPath)
        interactor?.handle(request)
    }
}
