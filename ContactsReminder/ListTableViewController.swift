//
//  ListTableViewController.swift
//  ContactsReminder
//
//  Created by Mavericks on 20/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ListTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    
    var toDoItems:NSMutableArray! = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    func loadData(){
        
        toDoItems.removeAllObjects()
        
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let results: NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: nil, managedObjectContext: moc)
        
        for toDo in results{
            let singleToDo: ToDoItem = toDo as! ToDoItem
            
            let identifier = singleToDo.identifier
            print(identifier)
            let dueDate = singleToDo.dueDate
            print(dueDate)
            let reminderText = singleToDo.note
            print(identifier)
            let contact:Contact = singleToDo.contact!
            
            let firstName = contact.firstName
            let lastName = contact.lastName
            let phoneNumber = contact.phoneNumber
            let email = contact.email
            
            let profileImage: UIImage = UIImage(data: contact.contactImage!)!
            
            let dict: NSDictionary = ["identifier" : identifier! ,"firstName":firstName!,"lastName":lastName!,"email": email!,"phoneNumber":phoneNumber!,"contactImage":profileImage, "dueDate": dueDate!, "reminderText": reminderText!]
            
            toDoItems.addObject(dict)
        }
        
        let dateSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        var sortedArray: NSArray = toDoItems.sortedArrayUsingDescriptors([dateSortDescriptor] )
        
        toDoItems = NSMutableArray(array: sortedArray)
        
        self.tableView.reloadData()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(toDoItems.count)
        return toDoItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListTableViewCell
        
        let dictionary:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
        
        let firstName:NSString = dictionary["firstName"] as! NSString
        let lastName:NSString = dictionary["lastName"] as! NSString

        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        
        let date: NSString = dateFormatter.stringFromDate(dictionary["dueDate"] as! NSDate)
        
        // Configure the cell...
        
        cell.nameLabel.text = (firstName as String) + " " + (lastName as String)
        cell.dueDateLabel.text = date as String

        //cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        cell.cImageView?.image = dictionary["contactImage"] as? UIImage
        cell.cImageView?.userInteractionEnabled = false
        cell.reminderLabel.text = dictionary["reminderText"] as! NSString as String
        
        cell.callButton.tag = indexPath.row
        cell.textButton.tag = indexPath.row
        cell.mailButton.tag = indexPath.row
        
        cell.callButton.addTarget(self, action: "callPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.textButton.addTarget(self, action: "textPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.mailButton.addTarget(self, action: "mailPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        

        return cell
    }
    
    func callPressed(sender: UIButton){
        let dict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        
        let phoneNumber = dict["phoneNumber"] as! NSString
        
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(phoneNumber)")!)
    }
    
    func textPressed(sender: UIButton){
        let dict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        
        let phoneNumber = dict["phoneNumber"] as! NSString
        
        if MFMessageComposeViewController.canSendText(){
            let controller: MFMessageComposeViewController = MFMessageComposeViewController()
            controller.recipients = ["\(phoneNumber)"]
            controller.messageComposeDelegate = self
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        switch result.rawValue{
        case MessageComposeResultSent.rawValue:
            controller.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultCancelled.rawValue:
            controller.dismissViewControllerAnimated(true, completion: nil)
        default:
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    
        //sself.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mailPressed(sender: UIButton){
        let dict:NSDictionary = toDoItems.objectAtIndex(sender.tag) as! NSDictionary
        
        let email = dict["email"] as! NSString
        
        if MFMailComposeViewController.canSendMail(){
            let controller: MFMailComposeViewController = MFMailComposeViewController()
            controller.setToRecipients(["\(email)"])
            controller.mailComposeDelegate = self
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
             if (toDoItems.count > 0){
                let infoDict:NSDictionary = toDoItems.objectAtIndex(indexPath.row) as! NSDictionary
                
                let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
                
                let identifier:NSString = infoDict.objectForKey("identifier") as! NSString
                
                let predicate:NSPredicate = NSPredicate(format: "identifier == '\(identifier)'")
                
                let results:NSArray = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(ToDoItem), withPredicate: predicate, managedObjectContext: moc)
                
                let toDoItemToDelete:ToDoItem = results.lastObject as! ToDoItem
                
                toDoItemToDelete.managedObjectContext!.deleteObject(toDoItemToDelete)
                
                SwiftCoreDataHelper.saveManagedObjectContext(moc)
                
                loadData()
                self.tableView.reloadData()
                
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
