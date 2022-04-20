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
    func draggingEnd(_ imageCanvas: ImageCanvas, sender: NSDraggingInfo)
}

class ImageCanvas: NSImageView {
    
    @IBOutlet weak var delegate: ImageCanvsDelegate?
    
    private func handleImage(at url: URL) {
        print("\(#fileID) \(#function) \(#line).")
        
        let image = NSImage(contentsOf: url)
        OperationQueue.main.addOperation {
            self.image = image
        }
    }
    
    private func handleError(_ error: Error) {
        print("\(#fileID) \(#function) \(#line).")
        
        OperationQueue.main.addOperation {
            if let window = self.window {
                self.presentError(error, modalFor: window, delegate: nil, didPresent: nil, contextInfo: nil)
            } else {
                self.presentError(error)
            }
        }
    }
    
    // MARK: - NSDraggingDestination
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("\(#fileID) \(#function) \(#line).")
        
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
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("\(#fileID) \(#function) \(#line).")
        
        delegate?.draggingEnd(self, sender: sender)
    }
}
