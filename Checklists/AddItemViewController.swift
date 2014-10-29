//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Fernando on 29/10/2014.
//  Copyright (c) 2014 Fernando. All rights reserved.
//

import UIKit


protocol AddItemViewControllerDelegate: class {

    func addItemViewControllerDidCancel(controller: AddItemViewController)
    func addItemViewController(controller:AddItemViewController, didFinishAddingItem item: ChecklistItem)

}


class AddItemViewController: UITableViewController,UITextFieldDelegate {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    weak var delegate : AddItemViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        textField.becomeFirstResponder();
    }
    
    
    @IBAction func done() {
//        println("content of the texfield: \(textField.text)")
//        dismissViewControllerAnimated(true, completion: nil);
        let item = ChecklistItem()
        item.text = textField.text
        item.checked = false
        delegate?.addItemViewController(self, didFinishAddingItem: item)
    }
    
    
    @IBAction func cancel(){
       // dismissViewControllerAnimated(true, completion: nil)
        delegate?.addItemViewControllerDidCancel(self)
    }

    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil;
    }
    
    
    //UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text;
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string);
        
        println(oldText)
        println(newText)
        
//        if newText.length > 0{
//            doneBarButton.enabled=true;
//        }else{
//            doneBarButton.enabled=false;
//        }
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true;
    }
    
}
