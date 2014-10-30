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

    weak var delegate : ItemDetailViewControllerDelegate?
    
    
    override func viewDidLoad() {
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled=true
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        textField.becomeFirstResponder();
    }
    
    
    @IBAction func done() {

        if let item = itemToEdit{
            item.text = textField.text
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        }else{
            let item = ChecklistItem()
            item.text = textField.text
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    
    @IBAction func cancel(){
       // dismissViewControllerAnimated(true, completion: nil)
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil;
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
