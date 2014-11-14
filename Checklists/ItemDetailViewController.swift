//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Fernando on 29/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit


protocol ItemDetailViewControllerDelegate: class {

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller:ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller:ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController,UITextFieldDelegate {

    
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    weak var delegate : ItemDetailViewControllerDelegate?
    
    var dueDate = NSDate()
    var datePickerVisible = false
    
    override func viewDidLoad() {
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled=true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    func updateDueDateLabel(){
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    
    }
    
    func showDatePicker(){
        datePickerVisible = true
        
        let indexPathDatePicker = NSIndexPath(forRow:2, inSection: 1)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker],withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath( indexPathDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as UIDatePicker
            datePicker.setDate(dueDate, animated: false)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        textField.becomeFirstResponder();
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1
        if indexPath.section == 1 && indexPath.row == 2 {
            // 2
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default,reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                // 3
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0,width: 320, height: 216))
                datePicker.tag = 100
                cell.contentView.addSubview(datePicker)
                // 4
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
        
            return cell
        // 5
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    
    }
    
    func dateChanged(datePicker: UIDatePicker){
                    dueDate = datePicker.date
                    updateDueDateLabel()
    }
    
    override func tableView(tableView: UITableView,var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
                    if indexPath.section == 1 && indexPath.row == 2 {
                        indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
                    }
                    return super.tableView(tableView,indentationLevelForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 1 && datePickerVisible {
                    return 3
            } else {
                    return super.tableView(tableView, numberOfRowsInSection: section)
            }
    
    }
    
    
    override func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
                return 217
        } else {
                return super.tableView(tableView,heightForRowAtIndexPath: indexPath)
                }
    }
    
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            textField.resignFirstResponder()
            if indexPath.section == 1 && indexPath.row == 1 {
                showDatePicker()
            }
            
    }
    
    @IBAction func done() {

        if let item = itemToEdit{
            item.text = textField.text
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }else{
            let item = ChecklistItem()
            item.text = textField.text
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    
    @IBAction func cancel(){
       // dismissViewControllerAnimated(true, completion: nil)
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
        
    }
    
    
    //UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text;
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string);
        
//        if newText.length > 0{
//            doneBarButton.enabled=true;
//        }else{
//            doneBarButton.enabled=false;
//        }
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true;
    }
    
}
