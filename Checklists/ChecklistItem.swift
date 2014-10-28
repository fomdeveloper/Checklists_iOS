//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Fernando on 28/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import Foundation


class ChecklistItem {
    var text = ""
    var checked = false;
    
    
    func toggleChecked(){
        checked = !checked;
    }
    
}