//
//  ViewModel.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Foundation
import Combine

final class ContactsViewModel {
    
    // MARK: - Properties
    
    var contactsSubject: PassthroughSubject<[Contact], CoreDataError> = .init()
    
    private var contacts: [Contact] = [] {
        didSet {
            contactsSubject.send(contacts)
        }
    }
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .init()) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Functions
    
    func fetchContacts() {
        Task { @MainActor [unowned self] in
            do {
                contacts = try await coreDataManager.fetchContacts()
            } catch let error as CoreDataError {
                contactsSubject.send(completion: .failure(error))
            }
        }
    }
    
    func addContact() {
        Task { @MainActor [unowned self] in
            do {
                contacts = try await coreDataManager.addContact(contact: Contact(id: UUID(), name: "Name #\(contacts.count)"))
            } catch let error as CoreDataError {
                contactsSubject.send(completion: .failure(error))
            }
        }
    }
    
    func deleteContact(index: Int) {
        let id = contacts[index].id
        
        Task { @MainActor [unowned self] in
            do {
                contacts = try await coreDataManager.deleteItemById(id: id)
            } catch let error as CoreDataError {
                contactsSubject.send(completion: .failure(error))
            }
        }
    }
}
