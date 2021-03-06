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
    
    @IBOutlet var playerView: UIView!
    
    var camera: CameraItem!
    private var playerAdapter = FlussonicPlayerAdapter()
    private var watcherView = FlussonicWatcherView()

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
        self.watcherView.frame = self.playerView.frame
        self.watcherView.alertDelegate = self
        self.playerView.addSubview(self.watcherView)
        watcherView.configure(withCameraItem: camera, playerAdapter: playerAdapter)
    }
    
    //MARK: - Navigation
    @IBAction func backButtonTouched(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CameraViewController: VLCMediaPlayerDelegate {
    
}
