//
//  SearchMenuController.swift
//  ShapeAnimation
//
//  Created by Zhang Yungui on 15/2/3.
//  Copyright (c) 2015 github.com/rhcad. All rights reserved.
//

import SwiftGraphics
import ShapeAnimation

class SearchMenuController: DetailViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var srearchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.borderStyle = .None
        textField.hidden = true
        textField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:textField, action:"resignFirstResponder"))
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        srearchButton.hidden = true
        textField.hidden = false
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.hidden = true
        srearchButton.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
