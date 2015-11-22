//
//  AddContactsTableViewController.swift
//  ContactsReminder
//
//  Created by Mavericks on 20/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit
import CoreData

class AddContactsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField! = UITextField()
    @IBOutlet weak var lastNameTextField: UITextField! = UITextField()
    @IBOutlet weak var emailTextField: UITextField! = UITextField()
    @IBOutlet weak var phoneNumberTextField: UITextField! = UITextField()
    @IBOutlet weak var contactImageView: UIImageView! = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "selectImage:")
        tapRecognizer.numberOfTapsRequired = 1
        
        contactImageView.addGestureRecognizer(tapRecognizer)
        contactImageView.userInteractionEnabled = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "touched")
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        
        self.tableView.addGestureRecognizer(tap)
        
    }
    
    func touched () {
        print("touched")
        self.view.endEditing(true)
    }
    
    func selectImage(recognizer:UITapGestureRecognizer) {
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        let pickedImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let smallPicture: UIImage = scaleImageWith(pickedImage, newSize: CGSizeMake(100, 100))
        
        var sizeOfImageView: CGRect = contactImageView.frame
        sizeOfImageView.size = smallPicture.size
         contactImageView.frame = sizeOfImageView
        
        contactImageView.image = pickedImage//smallPicture
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    
    func scaleImageWith(image:UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    @IBAction func done(sender: AnyObject) {
        
        let moc: NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        let contact: Contact = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Contact), managedObjectConect: moc) as! Contact
        contact.identifier = "\(NSDate())"
        contact.firstName = firstNameTextField.text
        contact.lastName = lastNameTextField.text
        contact.email = emailTextField.text
        contact.phoneNumber = phoneNumberTextField.text
        
        let contactImage: NSData = UIImagePNGRepresentation(contactImageView.image!)!
        
        contact.contactImage = contactImage
        
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
