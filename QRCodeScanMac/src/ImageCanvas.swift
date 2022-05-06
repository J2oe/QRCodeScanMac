//
//  ImageCanvas.swift
//  swiftdemoMac
//
//  Created by Joe on 2022/4/18.
//

import AppKit
import UniformTypeIdentifiers

@objc
protocol ImageCanvsDelegate: AnyObject {
    func draggingFinished(_ imageCanvas: ImageCanvas, sender: NSDraggingInfo?)
}

enum DragStatus {
case none
case entered
case exited
}

class ImageCanvas: NSImageView {
    
    @IBOutlet weak var delegate: ImageCanvsDelegate?
    
    var status: DragStatus = .none
    
    public func assignImageUrl(at url: URL) {
        print("\(#fileID) \(#function) \(#line). url: \(url)")
        
        self.handleImage(at: url)
        self.delegate?.draggingFinished(self, sender: nil)
    }
    
    private func handleImage(at url: URL) {
        print("\(#fileID) \(#function) \(#line). url: \(url)")
        
        let image = NSImage(contentsOf: url)
        self.image = image
    }
    
    private func handleError(_ error: Error) {
        print("\(#fileID) \(#function) \(#line).")
        
        if let window = self.window {
            self.presentError(error, modalFor: window, delegate: nil, didPresent: nil, contextInfo: nil)
        } else {
            self.presentError(error)
        }
    }
    
    // MARK: - NSDraggingDestination
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("\(#fileID) \(#function) \(#line).")
        self.status = .entered
        
        let result = sender.draggingSourceOperationMask.intersection([.copy])
        return result
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("\(#fileID) \(#function) \(#line).")
        
        let supportedClasses = [
            NSURL.self
        ]
        
        var acceptedTypes: [String]
        if #available(macOS 11.0, *) {
            acceptedTypes = [UTType.image.identifier]
        } else {
            acceptedTypes = [kUTTypeImage as String]
        }
        
        let searchOptions: [NSPasteboard.ReadingOptionKey: Any] = [
            .urlReadingFileURLsOnly: true,
            .urlReadingContentsConformToTypes: acceptedTypes
        ]
        
        sender.enumerateDraggingItems(options: [], for: nil, classes: supportedClasses, searchOptions: searchOptions) { (draggingItem, _, _) in
            print("\(#fileID) \(#function) \(#line).")
            
            switch draggingItem.item {
            case let imageFileURL as URL:
                self.handleImage(at: imageFileURL)
            default: break
            }
        }
        
        return true
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("\(#fileID) \(#function) \(#line).")
        self.status = .exited
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("\(#fileID) \(#function) \(#line).")
        
        if self.status == .entered {
            delegate?.draggingFinished(self, sender: sender)
        }
    }
}
