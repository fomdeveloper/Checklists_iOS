//
//  AllListViewController.swift
//  Checklists
//
//  Created by Fernando on 30/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {

    var lists : [Checklist]
   // var lists : Array<Checklist>
    
    required init(coder aDecoder:NSCoder){
    
        lists = [Checklist]()
        // lists = Array<Checklist>()
        
        super.init(coder:aDecoder)
        
        var list = Checklist(name:"Birthdays")
        lists.append(list)
        
    
        list = Checklist(name:"Groceries")
        lists.append(list)
        
        list = Checklist(name:"Cool Apps")
        lists.append(list)
        
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject?){
        if  segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as ChecklistViewController
            controller.checklist = sender as Checklist
        }
    
    }
    

    
    
    
}
