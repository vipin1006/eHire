//
//  ShowDetailsViewController.swift
//  EHire
//
//  Created by ajaybabu singineedi on 02/03/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class ShowDetailsViewController: NSViewController {
    
    var tag:Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello")
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        print("Hi")
    }
    
    @IBAction func cancelSheet(sender: AnyObject) {
        
        self.dismissViewController(self)
        
    }
}
