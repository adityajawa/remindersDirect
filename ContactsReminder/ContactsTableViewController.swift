//
//  ContactsTableViewController.swift
//  ContactsReminder
//
//  Created by Mavericks on 20/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit
import CoreData


protocol ContactSelectionDelegate{
    func userDidSelectContact(contactIdentifier:NSString)
}

class ContactsTableViewController: UITableViewController {
    
    var yourContact:NSMutableArray = NSMutableArray()
    var delegate: ContactSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // print("checking")
        loadData()
    }
    
    func loadData() {
        
        yourContact.removeAllObjects()
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        
        let results: NSArray = SwiftCoreDataHelper.fetchEntities("Contact", withPredicate: nil, managedObjectContext: moc)
        
        for singleContact in results {
            let contact: Contact = singleContact as! Contact
            let image = UIImage(data: contact.contactImage!)
            let dict: NSDictionary = ["identifier": contact.identifier!,"firstName":contact.firstName!,"lastName":contact.lastName!,"email":contact.email!,"phoneNumber":contact.phoneNumber!,"contactImage":image!]
            
           // let cImage:UIImage = UIImage(data: contact.contactImage!)!
          //  let newDict: NSDictionary = ["identifier": contact.identifier, "firstName": contact.firstName, "lastName": contact.lastName, "email":contact.email, "phoneNumber":contact.phoneNumber, "contactImage":cImage as! UIImage]
            yourContact.addObject(dict )
        }
        
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
        //print(yourContact.count)
        return yourContact.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! ContactsTableViewCell

        // Configure the cell...
        
        let dictionary: NSDictionary = yourContact.objectAtIndex(indexPath.row) as! NSDictionary
        
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        let email = dictionary["email"] as! String
        let phoneNumber = dictionary["phoneNumber"] as! String
        
        cell.contactLabel.text = firstName + " " + lastName
        cell.emailLabel.text = email
        cell.phoneLabel.text = phoneNumber
        
        let contactImage = dictionary["contactImage"] as! UIImage
        
//        var contactImageFrame:CGRect = cell.contactImageView.frame
//        contactImageFrame.size = CGSizeMake(75, 75)
//        cell.contactImageView.frame = contactImageFrame
        
        cell.cImageView.image = contactImage
        

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            let contactDict: NSDictionary = yourContact.objectAtIndex(indexPath.row) as! NSDictionary
            delegate!.userDidSelectContact(contactDict["identifier"] as! NSString)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
