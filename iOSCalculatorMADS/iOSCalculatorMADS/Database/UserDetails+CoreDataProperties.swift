//
//  UserDetails+CoreDataProperties.swift
//  iOSCalculatorMADS
//
//  Created by Kumar, Akash on 8/20/20.
//  Copyright © 2020 Kumar, Akash. All rights reserved.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var userID: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?

}
