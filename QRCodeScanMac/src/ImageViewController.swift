//
//  ViewController.swift
//  QRCodeScanMac
//
//  Created by Joe on 2022/4/19.
//

import Cocoa

class ImageViewController: NSViewController, ImageCanvsDelegate {

    @IBOutlet weak var accessoryLabel: NSTextField!
    
    @IBOutlet weak var imageCanvas: ImageCanvas!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.accessoryLabel.isEditable = false
        self.accessoryLabel.isSelectable = false
        self.accessoryLabel.placeholderString = "拖拽二维码图片，打开浏览器访问二维码关联地址。"
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // 鼠标左击
    override func mouseUp(with event: NSEvent) {
        print("\(#fileID) \(#function) \(#line).")
        
        if self.imageCanvas.image == nil {
            // TODO: 显示文件选择窗口
        } else {
            self.imageCanvas.image = nil
            self.accessoryLabel.isHidden = false
            self.syncTopreviewViewController(nil)
        }
    }

    func decterQRCode(_ image: NSImage) -> String? {
        print("\(#fileID) \(#function) \(#line).")
        
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
        print("\(#fileID) \(#function) \(#line).")
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.open(url, configuration: configuration)
    }
    
    // MARK: - ImageCanvsDelegate
    func draggingFinished(_ aImageCanvas: ImageCanvas, sender: NSDraggingInfo) {
        print("\(#fileID) \(#function) \(#line).")
        
        let content = self .convertQRCodeContent(aImageCanvas)
        
        // TODO: 配置可直接打开，或者显示预览
        self.syncTopreviewViewController(content)
//        self.openURLString(content)
    }
    
    func convertQRCodeContent(_ aImageCanvas: ImageCanvas) -> String {
        guard (aImageCanvas.image != nil) else {
            self.accessoryLabel.isHidden = false
            return ""
        }
        self.accessoryLabel.isHidden = true
        
        guard let string = self.decterQRCode(aImageCanvas.image!) else {
            return ""
        }
        
        return string
    }
    
    // MARK: - PreviewViewController
    func syncTopreviewViewController(_ string: String?) {
        print("\(#fileID) \(#function) \(#line). \(string ?? "")")
        
        guard let rootVC: NSSplitViewController = self.parent as? NSSplitViewController else {
            return
        }
        guard let previewVC: PreviewViewController = rootVC.splitViewItems.last?.viewController as? PreviewViewController else {
            return
        }
        previewVC.messageString = string
    }
}

