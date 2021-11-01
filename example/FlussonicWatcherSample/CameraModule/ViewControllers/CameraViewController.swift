//
//  CameraViewController.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import FlussonicSDK
import DynamicMobileVLCKit

class CameraViewController: UIViewController {
    
    @IBOutlet weak var watcherView: FlussonicWatcherView!
    var camera: CameraItem!
    private var playerAdapter = FlussonicPlayerAdapter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = camera.title ?? "unknown"
        self.navigationItem.title = "Камера " + title
        self.setupPlayer()
    }
    
    private func setupPlayer() {
        guard camera != nil else {
            return
        }
        watcherView.alertDelegate = self
        watcherView.setHideToolbarInPortrait(shouldHideToolbar: true)
        watcherView.configure(withCameraItem: camera, playerAdapter: playerAdapter)
        watcherView.setShowDebugInfo(newValue: true)
        watcherView.setTimelineMarkersV2(withTimelineMarkersV2: true)
    }

    
    //MARK: - Navigation
    @IBAction func backButtonTouched(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CameraViewController: VLCMediaPlayerDelegate {
    
}
