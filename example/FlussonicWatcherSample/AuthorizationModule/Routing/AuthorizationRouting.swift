//
//  AuthorizationRouting.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class AuthorizationRouting: NSObject {
    static func showAuthorizationScreen(fromVC: UIViewController) {
        let vc = UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "AuthorizationViewController") as! AuthorizationViewController
        fromVC.navigationController?.pushViewController(vc, animated: true)
    }
}
