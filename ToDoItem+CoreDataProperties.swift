//
//  ToDoItem+CoreDataProperties.swift
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

extension ToDoItem {

    @NSManaged var identifier: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var note: String?
    @NSManaged var contact: Contact?

}
