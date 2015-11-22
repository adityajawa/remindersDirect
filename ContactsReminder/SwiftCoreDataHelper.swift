

import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {
   
    class func directoryForDatabaseFilename()->NSString{
        return NSHomeDirectory().stringByAppendingString("/Library/Private Documents")
    }
    

    class func databaseFilename()->NSString{
        return "database.sqlite";
    }
    
    
    class func managedObjectContext()->NSManagedObjectContext{

        var error:NSError? = nil
        
        do{
            try NSFileManager.defaultManager().createDirectoryAtPath(SwiftCoreDataHelper.directoryForDatabaseFilename() as String, withIntermediateDirectories: true, attributes: nil)
        }catch{
            print("Directory Creation Error")
        }
        let path:NSString = "\(SwiftCoreDataHelper.directoryForDatabaseFilename()) + \(SwiftCoreDataHelper.databaseFilename())"
        
        let url:NSURL = NSURL(fileURLWithPath: path as String)
        
        let managedModel:NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)!
        
        let storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        do {
        try storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        }catch {
            print("persistant store error")
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        return managedObjectContext
        
        
    }
    
    class func insertManagedObject(className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
    
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectConect) as NSManagedObject
        
        return managedObject
        
    }
    
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        do{
            try managedObjectContext.save()
            
        }catch{
            return false
        }
        return true
    }

    
    class func fetchEntities(className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)!
        
        fetchRequest.entity = entetyDescription
        if (predicate != nil){
            fetchRequest.predicate = predicate!
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        var items:NSArray = NSArray()
        do{
            items = try managedObjectContext .executeFetchRequest(fetchRequest)
        }catch {
            
        }
        
        return items
    }
    
    
}
