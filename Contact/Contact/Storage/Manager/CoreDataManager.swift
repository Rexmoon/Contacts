//
//  CoreDataManager.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Foundation
import CoreData
import UIKit

actor CoreDataManager {
    
    // MARK: - Properties
    
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: Contact.identifier)
        container.loadPersistentStores { description, error in
            guard let error else { return }
            fatalError(error.localizedDescription)
        }
        
        return container.viewContext
    }()
    
    // MARK: - Initializers
    
    init() { }
    
    // MARK: - CRUD
    
    func addContact(contact: Contact) throws -> [Contact] {
        let newContact = ContactEntity(context: context)
        
        newContact.id = contact.id.uuidString
        newContact.name = contact.name
        
        do {
            try context.save()
            return try fetchContacts()
        } catch {
            throw error
        }
    }
    
    func fetchContacts() throws -> [Contact] {
        let fetchRequest: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        
        do {
            let contactsFetched = try context.fetch(fetchRequest)
            
            let contacts = try contactsFetched.map { contactEntity in
                guard let stringId = contactEntity.id,
                      let id = UUID(uuidString: stringId),
                      let name = contactEntity.name
                else { throw CoreDataError.nilProperty }
                
                return Contact(id: id, name: name)
            }
            
            return contacts
        } catch { throw error }
    }
    
    func deleteItemById(id: UUID) throws -> [Contact] {
        let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        do {
            let objects = try context.fetch(request)
            guard let contactToDelete = try objects.first(where: { contactEntity in
                guard let stringId = contactEntity.id,
                      let contactId = UUID(uuidString: stringId)
                else { throw CoreDataError.nilProperty }
                return contactId == id
            })
            else { throw CoreDataError.objectNotFound }
            context.delete(contactToDelete)
            try context.save()
            return try fetchContacts()
        } catch { throw error }
    }
}
