//
//  Contact.swift
//  Contact
//
//  Created by Jose Luna on 3/6/24.
//

import Foundation

struct Contact: Hashable {
    static var identifier: String = ContactEntity.description()
    
    let id: UUID
    let name: String
}
