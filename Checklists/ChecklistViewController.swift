//
//  ViewController.swift
//  Checklists
//
//  Created by Fernando on 28/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate {

    var items: [ChecklistItem];
    var checklist: Checklist!
    
    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]();
//        
//        let row0 = ChecklistItem();
//        row0.text = "cero";
//        row0.checked = false
//        items.append(row0);
//        
//        let row1 = ChecklistItem();
//        row1.text = "one";
//        row1.checked = true
//        items.append(row1);
//        
//        let row2:ChecklistItem = ChecklistItem();
//        row2.text = "two";
//        row2.checked = false
//        items.append(row2);
        
        
        super.init(coder:aDecoder);
        
        loadChecklistItems();
        
      //  println("Documents folder is \(documentsDirectory())")
     //   println("Data file path is \(dataFilePath())")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }

    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() ->String{
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func loadChecklistItems(){
    
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as [ChecklistItem]
                
                unarchiver.finishDecoding()
            }
        
        }
    
    }
    
    func saveChecklistItems(){
    
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding();
        data.writeToFile(dataFilePath(), atomically: true)
    
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell;
        
        let item = items[indexPath.row];
//        let label = cell.viewWithTag(1000) as UILabel;
//        label.text = item.text;
        
        configureTextForCell(cell,withChecklistItem:item);
        configureCheckMarkForCell(cell,withChecklistItem:item);
        
      //  label.text = "Cell \(indexPath.row) in listview";
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        saveChecklistItems()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = items[indexPath.row]
            item.toggleChecked();
    
            configureCheckMarkForCell(cell,withChecklistItem:item);
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        saveChecklistItems()
    }
    
    
    func configureTextForCell(cell:UITableViewCell , withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1000) as UILabel;
        label.text = item.text;
    }
    
    func configureCheckMarkForCell( cell:UITableViewCell , withChecklistItem item: ChecklistItem){

        let label = cell.viewWithTag(1001) as UILabel
        
        if item.checked {
            label.text = "√"
          //  cell.accessoryType = .Checkmark
        }else{
            label.text = ""
            //cell.accessoryType = .None
        }
        
        
    }
    
    // ItemDetailViewControllerDelegate
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {

        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        
        dismissViewControllerAnimated(true, completion: nil)
        
        saveChecklistItems()
    }
    
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        if let index = find(items, item){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    
        saveChecklistItems()
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
            
            
        
        }
    }
    
}

