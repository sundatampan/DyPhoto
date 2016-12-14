//
//  GenericPhoto.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import Foundation
import CoreData


class GenericPhoto: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    internal class func photoWithData(data: [String: AnyObject], entity entityName: String, inManagedObjectContext moc: NSManagedObjectContext) -> GenericPhoto? {
        
        var photo: GenericPhoto?
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "photoId == %@", data["id"] as! String)
        
        do {
            let photos = try moc.executeFetchRequest(fetchRequest) as! [GenericPhoto]
            if photos.count > 0 {
                photo = photos.first
            }
            else {
                photo = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: moc) as? GenericPhoto
                photo?.photoId = data["id"] as? String
            }
            
            if let caption = data["caption"]?["text"] as? String {
                photo?.caption = caption
            }
            if let createdTime = data["created_time"] as? String {
                photo?.createdTime = NSDate(timeIntervalSince1970: (createdTime as NSString).doubleValue)
            }
            
            if let imageUrl = data["images"]?["standard_resolution"] as? [String: AnyObject] {
                if let url = imageUrl["url"] as? String {
                    photo?.imageUrl = url
                }
            }
            if let link = data["link"] as? String {
                photo?.link = link
            }
            if let userData = data["user"] as? [String: AnyObject] {
                photo?.user =  User.userWithData(userData, inManagedObjectContext: moc)
            }
            if let locationData = data["location"] as? [String: AnyObject] {
                photo?.location =  Location.locationWithData(locationData, inManagedObjectContext: moc)
            }
        }
        catch {
            
        }
        
        return photo
    }
    
    internal class func photosWithEntity(entityName: String, inManagedObjectContext moc: NSManagedObjectContext) -> [GenericPhoto] {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdTime", ascending: false)]
        
        do {
            let photos = try moc.executeFetchRequest(fetchRequest) as! [GenericPhoto]
            return photos
        }
        catch { }
        
        return []
    }
}
