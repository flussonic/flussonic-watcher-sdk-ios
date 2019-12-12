//
//  CameraService.swift
//  ErlyVideo
//
//  Created by Dmitry on 19/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import FlussonicSDK

typealias RequestCamerasList = (_ cameras:[CameraItem], _ error: String?) -> Void

class CameraService: MainService {
    
    static let shared: CameraService = { CameraService() }()
    
    func requestCamerasList(completion: @escaping RequestCamerasList) {
        
        let url = host + "vsaas/api/v2/cameras"
        
        sendRequest(requestType: .get, url: url, parameters: nil, paramsEncoding: URLEncoding.default) { (jsonData, isConnection, error) in
            if !isConnection {
                completion([], "No internet connection")
                return
            }
            
            var allCameras: [CameraItem] = []
            if (error == nil) {
                do{
                    let data = try jsonData?.rawData()
                    allCameras = try JSONDecoder().decode([CameraItem].self,from: data!)
                    completion(allCameras, nil)
                    return
                }catch let jsonErr {
                    print("Error while parsing jsonData", jsonErr)
                    completion([], jsonErr.localizedDescription)
                }
            }
            completion([], "Ошибка загрузки")
        }
    }
}


    

