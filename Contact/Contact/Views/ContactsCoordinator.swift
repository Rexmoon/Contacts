//
//  ContactsCoordinator.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Foundation

final class ContactsCoordinator<R: AppRouter> {
    
    // MARK: - Properties
    
    private let router: R
    
    private lazy var contactsViewModel: ContactsViewModel = {
        ContactsViewModel()
    }()
    
     lazy var contactsViewController: ContactsCollectionViewController = {
        ContactsCollectionViewController(viewModel: contactsViewModel)
    }()
    
    init(router: R) {
        self.router = router
    }
}

// MARK: - Coordinator

extension ContactsCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(contactsViewController, animated: true)
    }
}
