//
//  AuthorizationService.swift
//  ErlyVideo
//
//  Created by Dmitry on 19/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

typealias AuthorizationRequestCompletion = (_ error: String?) -> Void

class AuthorizationService: MainService {
    
    static let shared: AuthorizationService = { AuthorizationService() }()
    
    var session = ""
    // MARK: - Authorization
    
    func requestAuthorization(login: String, password: String, completion: @escaping AuthorizationRequestCompletion) {
        
        let url = host + "vsaas/api/v2/auth/login"
        
        
        var params: [String:AnyObject] = [:]
        params["login"] = login as AnyObject
        params["password"] = password as AnyObject
        
        sendRequest(requestType: .post, url: url, parameters: params, paramsEncoding: URLEncoding.default) { (result, isConnection, error) in
            
            if isConnection == false {
                completion("Проверьте подключение к сети Интернет и попробуйте еще раз.")
                return
            }
            
            if let error = result?["error_message"].string {
                completion(error)
                return
            }
            
            if let session = result?["session"].string {
                self.session = session
                completion(nil)
            }
            completion("Auth error")
        }
    }

}
