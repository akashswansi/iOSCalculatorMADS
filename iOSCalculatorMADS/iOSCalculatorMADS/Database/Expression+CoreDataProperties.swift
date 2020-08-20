//
//  Expression+CoreDataProperties.swift
//  iOSCalculatorMADS
//
//  Created by Kumar, Akash on 8/20/20.
//  Copyright © 2020 Kumar, Akash. All rights reserved.
//
//

import Foundation
import CoreData


extension Expression {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expression> {
        return NSFetchRequest<Expression>(entityName: "Expression")
    }

    @NSManaged public var expression: String?
    @NSManaged public var results: String?

}
