//
//  Extensao.swift
//  ProjetoBRQ
//
//  Created by Catia Miranda de Souza on 03/12/19.
//  Copyright © 2019 Catia Miranda de Souza. All rights reserved.
//

import UIKit
import CoreData

//Extensao usada no CoreDate
extension UIViewController{
    
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
