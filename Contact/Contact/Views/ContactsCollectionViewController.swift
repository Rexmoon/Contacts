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
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
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
        super.init(collectionViewLayout: UICollectionViewLayout())
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
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        var listCellConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listCellConfiguration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { [unowned self] action, view, completion in
                deleteContact(indexPath: indexPath)
            }
            
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return UICollectionViewCompositionalLayout.list(using: listCellConfiguration)
    }
    
    private func setupUI() {
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [addButton]
        collectionView.setCollectionViewLayout(collectionViewLayout(), animated: true)
    }
    
    private func bindUI() {
        viewModel.fetchContacts()
        
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
    
    private func deleteContact(indexPath: IndexPath) {
        viewModel.deleteContact(index: indexPath.row)
    }
    
    @objc
    private func addButtonClicked() {
        viewModel.addContact()
    }
}

// MARK: - Collection View Delegate

extension ContactsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
