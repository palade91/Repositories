//
//  CoreItem+CoreDataProperties.swift
//  Repositories
//
//  Created by Catalin Palade on 31/01/2021.
//
//

import Foundation
import CoreData


extension CoreItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreItem> {
        return NSFetchRequest<CoreItem>(entityName: "CoreItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var fullName: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var forks: Int64
    @NSManaged public var openIssues: Int64
    @NSManaged public var watchers: Int64
    @NSManaged public var createdAt: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var ownerName: String?
    @NSManaged public var ownerID: Int64
    @NSManaged public var ownerAvatarURL: String?

}

extension CoreItem : Identifiable {

}
