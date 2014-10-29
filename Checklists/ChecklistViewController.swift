//
//  ViewController.swift
//  Checklists
//
//  Created by Fernando on 28/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController,AddItemViewControllerDelegate {

    var items: [ChecklistItem];
    
    
    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]();
        
        let row0 = ChecklistItem();
        row0.text = "cero";
        row0.checked = false
        items.append(row0);
        
        let row1 = ChecklistItem();
        row1.text = "one";
        row1.checked = true
        items.append(row1);
        
        let row2:ChecklistItem = ChecklistItem();
        row2.text = "two";
        row2.checked = false
        items.append(row2);
        
        
        super.init(coder:aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = items[indexPath.row]
            item.toggleChecked();
    
            configureCheckMarkForCell(cell,withChecklistItem:item);
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    
    func configureTextForCell(cell:UITableViewCell , withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1000) as UILabel;
        label.text = item.text;
    }
    
    func configureCheckMarkForCell( cell:UITableViewCell , withChecklistItem item: ChecklistItem){
       // let item = items[indexPath.row]
        if item.checked {
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        
    }
    
    // AddItemViewControllerDelegate
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {

        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            
            let controller = navigationController.topViewController as AddItemViewController
            
            controller.delegate = self
        }
    }
    
}

