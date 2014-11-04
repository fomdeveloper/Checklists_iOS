//
//  AllListViewController.swift
//  Checklists
//
//  Created by Fernando on 30/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController,ListDetailViewControllerDelegate {

    var lists : [Checklist]
   // var lists : Array<Checklist>
    
    
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
    
    
    
    required init(coder aDecoder:NSCoder){
    
        lists = [Checklist]()
        // lists = Array<Checklist>()
        
        super.init(coder:aDecoder)
        
  
        loadChecklists()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = lists[indexPath.row]
        cell.textLabel.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        return cell;
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist = lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView,accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath){
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        let controller = navigationController.topViewController as ListDetailViewController
        
        controller.delegate = self
        
        let checklist = lists[indexPath.row]
        
        controller.checklistToEdit = checklist
        
        presentViewController(navigationController,animated:true,completion:nil)
        
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject?){
        if  segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as ChecklistViewController
            controller.checklist = sender as Checklist
        }else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as UINavigationController;
            let controller = navigationController.topViewController as ListDetailViewController;
            
            controller.delegate = self;
            controller.checklistToEdit = nil;
        }
    
    }
    

    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true,completion:nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection:0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths,withRowAnimation:.Automatic)
        
        dismissViewControllerAnimated(true,completion:nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    
        if let index = find(lists,checklist) {
            let indexPath = NSIndexPath(forRow:index, inSection:0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                cell.textLabel.text = checklist.name
            }
        }
        dismissViewControllerAnimated(true,completion:nil)
    
    }

    override func tableView(tableView: UITableView,commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths,withRowAnimation: .Automatic)
    }

}






