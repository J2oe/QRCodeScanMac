//
//  SplitViewController.swift
//  QRCodeScanMac
//
//  Created by Joe on 2022/5/6.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.preferredContentSize = CGSize(width: 520, height: 300)
    }
    
}
