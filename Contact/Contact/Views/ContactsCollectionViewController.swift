//
//  ViewController.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import UIKit
import Combine

final class ContactsCollectionViewController: UICollectionViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Contact>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Contact>
    
    // MARK: - Properties
    
    private var subscriber: AnyCancellable?
    private let viewModel: ContactsViewModel
    
    private lazy var dataSource: DataSource = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Contact> { cell, _, contact in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = contact.name
            cell.contentConfiguration = configuration
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }()
    
    
    
    // MARK: - Initializers
    
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.collectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    // MARK: - Functions
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
                print("Deleting...")
            }
            
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func setupUI() {
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindUI() {
        viewModel.loadData()
        
        subscriber = viewModel.contactsSubject
            .sink { completion in
                switch completion {
                case .failure(let error): fatalError(error.localizedDescription)
                case .finished: print("Finished")
                }
            } receiveValue: { contacts in
                self.applySnapshot(contacts: contacts)
            }

    }
    
    private func applySnapshot(contacts: [Contact]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(contacts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

