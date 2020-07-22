//
//  MainService.swift
//  ErlyVideo
//
//  Created by Dmitry on 19/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias RequestJsonCompletion = (_ results: JSON?, _ isConnection: Bool, _ error: Error?) -> Void
typealias OnlyErrorCompletion = (_ error: String?) -> Void

class MainService: NSObject {
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    internal let host = "https://demo-watcher.flussonic.com/"
    
    public func sendRequest(requestType: HTTPMethod, url:String, parameters:[String: AnyObject]?, paramsEncoding: ParameterEncoding, completion:@escaping RequestJsonCompletion) {
        
        if let manager = Alamofire.NetworkReachabilityManager(host: "www.apple.com") {
            if !(reachabilityManager?.isReachable)! {
                completion(nil, false, nil)
                return
            }
        }
        
        var headers: HTTPHeaders?
        
        if AuthorizationService.shared.session != "" {
            headers = ["x-vsaas-session" : AuthorizationService.shared.session]
        }
        
        AF.request(url as URLConvertible, method: requestType, parameters: parameters, encoding: paramsEncoding, headers: headers).responseJSON { (dataResponse) in
            print(parameters as Any)
            debugPrint(dataResponse)
            switch dataResponse.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
                DispatchQueue.main.async {
                    completion(json, true, nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, true, error)
                }
                print(dataResponse)
            }
        }
    }
    
}
