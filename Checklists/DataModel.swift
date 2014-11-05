//
//  DataModel.swift
//  Checklists
//
//  Created by Fernando on 05/11/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int{
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
        }
    
    }
    

    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults(){
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    
    func handleFirstTime(){
    
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "list")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
    
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() ->String{
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func loadChecklists(){
        
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
                
                unarchiver.finishDecoding()
                sortChecklists()
            }
            
        }
        
    }
    
    func saveChecklists(){
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding();
        data.writeToFile(dataFilePath(), atomically: true)
        
    }
    
    func sortChecklists() {
        lists.sort({ checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending })
    }
    
}