//
//  Checklist.swift
//  Checklists
//
//  Created by Fernando on 30/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name=""
    var items = [ChecklistItem]() // var items:[ChecklistItem] = [ChecklistItem]()
    
    
    
    init(name: String){
        self.name = name
        super.init()
    }
    
    
    
    required init(coder aDecoder: NSCoder){
        name = aDecoder.decodeObjectForKey("Name") as String
        items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
        super.init()
    
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey:"Name")
        aCoder.encodeObject(items, forKey:"Items")
    }
    
}
