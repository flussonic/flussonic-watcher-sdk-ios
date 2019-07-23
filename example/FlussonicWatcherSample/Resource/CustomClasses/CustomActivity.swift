//
//  CustomActivity.swift
//  ErlyVideo
//
//  Created by Dmitry on 24/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import UIKit

class CustomActivity: NSObject {
    
    let animationView = UIActivityIndicatorView()
    var container: UIView = UIView()
    
    static public let shared: CustomActivity = { CustomActivity() }()
    
    func show(uiView: UIView) {
        DispatchQueue.main.async {
            self.container.alpha = 0
            self.container.frame = UIScreen.main.bounds
            self.container.center = uiView.convert(uiView.center, from: uiView.superview)
            self.container.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            self.animationView.stopAnimating()
            uiView.addSubview(self.container)
            self.animationView.center = uiView.convert(uiView.center, from: uiView.superview)
            self.container.addSubview(self.animationView)
            self.animationView.startAnimating()
            
            UIView.animate(withDuration: 0.5) {
                self.container.alpha = 1
            }
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.container.alpha = 0
        }) { (result) in
            self.animationView.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.container.removeFromSuperview()
        }
    }
    
}
