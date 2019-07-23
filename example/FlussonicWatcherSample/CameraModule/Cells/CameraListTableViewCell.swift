//
//  CameraListTableViewCell.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import FlussonicSDK

class CameraListTableViewCell: UITableViewCell {
    
    @IBOutlet var cameraNameLabel: UILabel!
    @IBOutlet var cameraStatusLabel: UILabel!
    
    @IBOutlet weak var cameraPreviewView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var cameraView: PreviewMp4View!
    
    func customizeCell(camera: CameraModel) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.cameraView = PreviewMp4View(frame: self.cameraPreviewView.frame)
            self.cameraNameLabel.text = camera.title
            if camera.isOnline {
                self.activityIndicator.isHidden = false
                self.cameraStatusLabel.text = "online"
                self.cameraStatusLabel.textColor = UIColor.green
                self.contentView.addSubview(self.cameraView)
                if let url = URL(string: camera.urlForPreview) {
                    self.cameraView.configure(withUrl: url, cacheKey: camera.urlForPreview)
                }
            } else {
                self.activityIndicator.isHidden = true
                self.cameraStatusLabel.text = "offline"
                self.cameraStatusLabel.textColor = UIColor.red
            }
        }
    }
    
    
}
