//
//  ViewController.swift
//  QRCodeScanMac
//
//  Created by Joe on 2022/4/19.
//

import Cocoa

class ImageViewController: NSViewController, ImageCanvsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func decterQRCode(_ image: NSImage) -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil)
        guard let features = detector?.features(in: CIImage(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)) else {
            return nil
        }
        guard let feature = features.first as? CIQRCodeFeature else {
            return nil
        }
        let result = feature.messageString
        return result
    }
    
    func openURLString(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.open(url, configuration: configuration)
    }
    
    // MARK: - ImageCanvsDelegate
    func draggingEnd(_ imageCanvas: ImageCanvas, sender: NSDraggingInfo) {
        guard (imageCanvas.image != nil) else {
            return
        }
        
        guard let string = self.decterQRCode(imageCanvas.image!) else {
            return
        }
        
        self.openURLString(string)
    }

}

