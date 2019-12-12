//
//  CameraRouting.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import FlussonicSDK

class CameraRouting: NSObject {
    static func showCameraScreen(fromVC: UIViewController, camera: CameraItem) {
        let vc = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.camera = camera
        fromVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func showCameraListScreen(fromVC: UIViewController) {
        let vc = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CamerasListViewController") as! CamerasListViewController
        fromVC.navigationController?.pushViewController(vc, animated: true)
    }
}
