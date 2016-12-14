//
//  Location.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    class func locationWithData(data: [String: AnyObject], inManagedObjectContext moc: NSManagedObjectContext) -> Location? {
        
        var location: Location?
        
        let fetchRequest = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "locationId == %@", data["id"] as! NSNumber)
        
        do {
            let locations = try moc.executeFetchRequest(fetchRequest) as! [Location]
            if locations.count > 0 {
                location = locations.first
            }
            else {
                location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as? Location
                location?.locationId = data["id"] as? String
                
                if let latitude = data["latitude"] as? NSNumber {
                    location?.latitude = latitude
                }
                if let longitude = data["longitude"] as? NSNumber {
                    location?.longitude = longitude
                }
                if let name = data["name"] as? String {
                    location?.name = name
                }
            }
        }
        catch {
            
        }
        
        return location
    }
}
