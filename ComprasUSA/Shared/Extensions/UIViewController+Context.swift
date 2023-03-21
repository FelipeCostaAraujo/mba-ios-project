//
//  UIViewController+Context.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 06/12/22.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
