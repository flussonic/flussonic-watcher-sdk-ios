//
//  CameraListTableViewCell.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import FlussonicSDK

class CameraListTableViewCell: UITableViewCell, PreviewMp4ViewStatusListener {
    
    @IBOutlet var cameraNameLabel: UILabel!
    @IBOutlet var cameraStatusLabel: UILabel!
    
    @IBOutlet weak var cameraPreviewView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cameraView: PreviewMp4View!
    
    public var cameraItem: CameraItem? {
        didSet {
            guard let `cameraItem` = cameraItem else { return  }

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.cameraView = PreviewMp4View(frame: self.cameraPreviewView.frame)
            self.cameraNameLabel.text = cameraItem.title
            if cameraItem.isAlive() {
                self.activityIndicator.isHidden = false
                self.cameraStatusLabel.text = "online"
                self.cameraStatusLabel.textColor = UIColor.green
                self.contentView.addSubview(self.cameraView)
                let camCache = "\(cameraItem.name)_\(lrint(Date().timeIntervalSince1970/10))" // setting cache updating every 10 seconds
                self.cameraView.configure(withCameraItem: cameraItem, cacheKey: camCache)
            } else {
                self.activityIndicator.isHidden = true
                self.cameraStatusLabel.text = "offline"
                self.cameraStatusLabel.textColor = UIColor.red
            }
        }
    }
    }
        
    override func prepareForReuse() {
        cameraView.reset()
    }
        
    func onStatusChanged(_ status: Int8, _ code: String, _ message: String) {
        if status == PreviewMp4StatusEnum.error.rawValue {
                print("onstatusChanged error \(status) \(message)")
        }
    }
    
    
    
}
