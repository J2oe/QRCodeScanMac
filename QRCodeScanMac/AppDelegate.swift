//
//  AppDelegate.swift
//  QRCodeScanMac
//
//  Created by Joe on 2022/4/19.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag {
            //
        } else {
            NSApplication.shared.windows.first?.makeKeyAndOrderFront(nil)
        }
        return true
    }

}

