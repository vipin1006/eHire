//
//  Utility.swift
//  EHire
//
//  Created by Pavithra G. Jayanna on 05/01/16.
//  Copyright © 2016 Exilant Technologies. All rights reserved.
//

import Cocoa

class Utility: NSObject
{
    class func alertPopup(data:String,informativeText:String ,isCancelBtnNeeded:Bool , let okCompletionHandler:(() -> Void)?)
    {
        let alert:NSAlert = NSAlert()
        alert.messageText = data
        
        alert.informativeText = informativeText
        if isCancelBtnNeeded{
            alert.addButtonWithTitle("YES")
            alert.addButtonWithTitle("NO")

        }
        else{
            alert.addButtonWithTitle("OK")
        }
        alert.alertStyle = NSAlertStyle.CriticalAlertStyle
        let res = alert.runModal()
        if res == NSAlertFirstButtonReturn
        {
            if let completion = okCompletionHandler
            {
                completion()
            }
        }
    }
}
