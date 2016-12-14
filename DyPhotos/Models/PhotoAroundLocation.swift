//
//  PhotoAroundLocation.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import CoreData


class PhotoAroundLocation: GenericPhoto {

// Insert code here to add functionality to your managed object subclass

    class func photoWithData(data: [String: AnyObject], inManagedObjectContext moc: NSManagedObjectContext) -> PhotoAroundLocation? {
        return GenericPhoto.photoWithData(data, entity: "PhotoAroundLocation", inManagedObjectContext: moc) as? PhotoAroundLocation
    }
    
    class func photosWithLocation(locationId: String, inManagedObjectContext moc: NSManagedObjectContext) -> [PhotoAroundLocation] {
        
        var photos = [PhotoAroundLocation]()
        
        let request = NSFetchRequest(entityName: "PhotoAroundLocation")
        request.predicate = NSPredicate(format: "location.locationId == %@", locationId)
        request.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        
        do {
            photos = try moc.executeFetchRequest(request) as! [PhotoAroundLocation]
        }
        catch {
            
        }
        
        return photos
    }
}
