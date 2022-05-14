//
//  PreviewViewController.swift
//  QRCodeScanMac
//
//  Created by Joe on 2022/4/27.
//

import Cocoa

class PreviewViewController: NSViewController {

    @IBOutlet weak var messageTextField: NSTextField!
    
    @IBOutlet weak var visitButton: NSButton!
    
    public var messageString: String? {
        didSet {
            if messageString == nil || messageString!.count == 0 {
                self.messageTextField.isHidden = true
                self.messageTextField.stringValue = ""
                
                self.visitButton.isHidden = true
                self.visitButton.isEnabled = false
            } else {
                self.messageTextField.isHidden = false
                self.messageTextField.stringValue = messageString!
                
                self.visitButton.isHidden = false
                self.visitButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.frame = NSRect(x: 0, y: 0, width: 260, height: 300);
        
        self.messageTextField.isEditable = false
        self.messageTextField.isBordered = false
        self.messageTextField.isHidden = true
        
        self.visitButton.title = "Visit"
        self.visitButton.isHidden = true
        self.visitButton.target = self
        self.visitButton.action = #selector(didClickVisitButton)
    }
    
    @objc
    func didClickVisitButton() {
        print("\(#fileID) \(#function) \(#line).")
        
        self.openURLString(self.messageTextField.stringValue)
    }
    
    func openURLString(_ urlString: String) {
        print("\(#fileID) \(#function) \(#line).")
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.open(url, configuration: configuration)
    }
    
}
