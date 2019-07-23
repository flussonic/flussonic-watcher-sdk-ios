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
    
    var camera: CameraModel!
    private var playerAdapter = FlussonicPlayerAdapter()
    private var watcherView = FlussonicWatcherView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Камера " + camera.title
        self.setupPlayer()
    }
    
    private func setupPlayer() {
        guard let url = URL(string: camera.urlForPlayer) else {
            return
        }
        self.watcherView.frame = self.playerView.frame
        self.playerView.addSubview(self.watcherView)
        watcherView.configure(withUrl: url, playerAdapter: playerAdapter)
    }
    
    //MARK: - Navigation
    @IBAction func backButtonTouched(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CameraViewController: VLCMediaPlayerDelegate {
    
}
