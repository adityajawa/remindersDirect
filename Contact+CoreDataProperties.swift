//
//  Contact+CoreDataProperties.swift
//  ContactsReminder
//
//  Created by Mavericks on 20/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var identifier: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var email: String?
    @NSManaged var contactImage: NSData?
    @NSManaged var toDoItem: NSSet?

}
