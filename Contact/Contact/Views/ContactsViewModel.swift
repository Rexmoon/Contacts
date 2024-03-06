//
//  ViewModel.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Combine

final class ContactsViewModel {
    
    // MARK: - Properties
    
    var contactsSubject: CurrentValueSubject<[Contact], CoreDataError> = .init([])
    
    // MARK: - Functions
    
    func loadData() {
        let contacts = (0...100).map { Contact(name: "Contact # \($0)") }
        contactsSubject.send(contacts)
    }
}
