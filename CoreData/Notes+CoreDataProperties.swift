//
//  Notes+CoreDataProperties.swift
//  MyNotes
//
//  Created by admin on 12.02.2019.
//  Copyright © 2019 admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var noteCompletedOrNot: Bool
    @NSManaged public var textNote: String?
    @NSManaged public var timeRemind: NSDate?
    @NSManaged public var uuid: String?

}
