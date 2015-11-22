//
//  AddReminderViewController.swift
//  ContactsReminder
//
//  Created by Mavericks on 20/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit
import CoreData

class AddReminderViewController: UIViewController, ContactSelectionDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var reminderText: UITextField!
    
    var pickedDate:NSDate!
    var contactIdentifierString:NSString!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePicked(sender: UIDatePicker) {
        pickedDate = sender.date
        
    }
    @IBAction func done(sender: AnyObject) {
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(contactIdentifierString)'", argumentArray: nil)
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        
        let contact: Contact = results.lastObject as! Contact
        
        let todoitem: ToDoItem = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(ToDoItem), managedObjectConect: moc) as! ToDoItem
        todoitem.identifier = "\(NSDate())"
        if pickedDate != nil {
        todoitem.dueDate = pickedDate
        }else{
            todoitem.dueDate = NSDate()
        }
        todoitem.note = reminderText.text
        todoitem.contact = contact
        
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    func userDidSelectContact(contactIdentifier: NSString) {
        
        contactIdentifierString = contactIdentifier
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let predicate: NSPredicate = NSPredicate(format: "identifier == '\(contactIdentifier)'", argumentArray: nil)
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Contact), withPredicate: predicate, managedObjectContext: moc)
        
        let contact: Contact = results.lastObject as! Contact
        
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
        
        imageView.image = UIImage(data: contact.contactImage!)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "contactSegue" {
            let viewController: ContactsTableViewController = segue.destinationViewController as! ContactsTableViewController
            viewController.delegate = self
        }
    }
    

}
