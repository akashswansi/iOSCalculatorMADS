//
//  DataBaseHelper.swift
//  iOSCalculatorMADS
//
//  Created by Kumar, Akash on 8/20/20.
//  Copyright © 2020 Kumar, Akash. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DatabaseHelper {
    static var sharedInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func saveData(object:[String:String]){
        let userDetail = NSEntityDescription.insertNewObject(forEntityName: "UserDetails", into: context!) as! UserDetails
        userDetail.firstName = object["firstName"]
        userDetail.lastName = object["lastName"]
        userDetail.userID = object["userID"]
        userDetail.password = object["password"]
        do{
            try context?.save()
        }catch{
            print("data is not save")
        }
    }
    
    func saveExpressionData(object:[String:String]){
        let expression = NSEntityDescription.insertNewObject(forEntityName: "Expression", into: context!) as! Expression
        expression.expression = object["expression"]
        expression.results = object["results"]
        do {
            try context?.save()
        }catch{
            print("data is not save")
        }
    }
    
    func getExpressionData() ->[Expression]{
        var expressions = [Expression]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Expression")
        do {
            expressions = try context?.fetch(fetchRequest) as! [Expression]
        }catch{
            print("cannot get the data")
        }
        return expressions
    }
    
    func getUserDetailsData() ->[UserDetails]{
        var userDetail = [UserDetails]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetails")
        do {
            userDetail = try context?.fetch(fetchRequest) as! [UserDetails]
        }catch{
            print("cannot get the data")
        }
        return userDetail
    }
}
