//
//  DataCommunicator.swift
//  EHire
//
//  Created by Sudhanshu Saraswat on 11/12/15.
//  Copyright © 2015 Exilant Technologies. All rights reserved.
//

import AppKit

protocol DataCommunicator {
    
    func sendData<T>(sendingData:T,sender:String)
    
}