//
//  AllListViewController.swift
//  Checklists
//
//  Created by Fernando on 30/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController,ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    var dataModel: DataModel!
   // var lists : [Checklist]
   // var lists : Array<Checklist>
    
//    required init(coder aDecoder:NSCoder){
//    
//        lists = [Checklist]()
//        // lists = Array<Checklist>()
//        
//        super.init(coder:aDecoder)
//        
//  
//        loadChecklists()
//        
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No items)"
        }else if count == 0 {
            cell.detailTextLabel!.text = "All done!"
        }else{
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        cell.imageView.image = UIImage(named: checklist.iconName)
        
        return cell;
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView,accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath){
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        let controller = navigationController.topViewController as ListDetailViewController
        
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        
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
    //    let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
    //    let indexPath = NSIndexPath(forRow: newRowIndex, inSection:0)
    //    let indexPaths = [indexPath]
        
    //    tableView.insertRowsAtIndexPaths(indexPaths,withRowAnimation:.Automatic)
        
        dismissViewControllerAnimated(true,completion:nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    
//        if let index = find(dataModel.lists,checklist) {
//            let indexPath = NSIndexPath(forRow:index, inSection:0)
//            if let cell = tableView.cellForRowAtIndexPath(indexPath){
//                cell.textLabel.text = checklist.name
//            }
//        }
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true,completion:nil)
    
    }

    override func tableView(tableView: UITableView,commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths,withRowAnimation: .Automatic)
    }
    
    
    
    //UINavigationControllerDelegate method
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool){
    
        if  viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    
    }
    

}






