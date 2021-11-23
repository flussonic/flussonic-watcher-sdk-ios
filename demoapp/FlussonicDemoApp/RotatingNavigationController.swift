//
//  RotatingNavigationController.swift
//  Flussonic
//
//  Created by Garafutdinov Ravil on 24/09/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit

class RotatingNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
