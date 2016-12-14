//
//  GenericPhoto+CoreDataProperties.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GenericPhoto {

    @NSManaged var caption: String?
    @NSManaged var createdTime: NSDate?
    @NSManaged var imageUrl: String?
    @NSManaged var link: String?
    @NSManaged var photoId: String?
    @NSManaged var user: User?
    @NSManaged var location: Location?

}
