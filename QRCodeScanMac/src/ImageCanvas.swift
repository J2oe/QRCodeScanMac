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
    
    /// Directory URL used for accepting file promises.
    private lazy var destinationURL: URL = {
        let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Drops")
        try? FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        return destinationURL
    }()
    
    /// Queue used for reading and writing file promises.
    private lazy var workQueue: OperationQueue = {
        let providerQueue = OperationQueue()
        providerQueue.qualityOfService = .userInitiated
        return providerQueue
    }()
    
    /// Displays a progress indicator.
    private func prepareForUpdate() {
        print("\(#function)_\(#line).")
    }
    
    /// Updates the canvas with a given image.
    private func handleImage(_ image: NSImage?) {
        print("\(#function)_\(#line).")
        self.image = image
    }
    
    /// Updates the canvas with a given image file.
    private func handleFile(at url: URL) {
        print("\(#function)_\(#line).")
        let image = NSImage(contentsOf: url)
        OperationQueue.main.addOperation {
            self.handleImage(image)
        }
    }
    
    /// Displays an error.
    private func handleError(_ error: Error) {
        print("\(#function)_\(#line).")
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
        print("\(#function)_\(#line).")
        let result = sender.draggingSourceOperationMask.intersection([.copy])
        return result
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("\(#function)_\(#line).")
        let supportedClasses = [
            NSFilePromiseReceiver.self,
            NSURL.self
        ]
        
        // Look for possible URLs we can consume (image URLs).
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
            switch draggingItem.item {
            case let filePromiseReceiver as NSFilePromiseReceiver:
                self.prepareForUpdate()
                filePromiseReceiver.receivePromisedFiles(atDestination: self.destinationURL, options: [:],
                                                         operationQueue: self.workQueue) { (fileURL, error) in
                    if let error = error {
                        self.handleError(error)
                    } else {
                        self.handleFile(at: fileURL)
                    }
                }
            case let fileURL as URL:
                self.handleFile(at: fileURL)
            default: break
            }
        }
        
        return true
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("\(#function)_\(#line).")
        delegate?.draggingEnd(self, sender: sender)
    }
}
