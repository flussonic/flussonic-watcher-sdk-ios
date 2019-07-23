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

typealias RequestCamerasList = (_ cameras:[CameraModel], _ error: String?) -> Void

class CameraService: MainService {
    
    static let shared: CameraService = { CameraService() }()
    
    func requestCamerasList(completion: @escaping RequestCamerasList) {
        
        let url = host + "vsaas/api/v2/cameras"
        
        sendRequest(requestType: .get, url: url, parameters: nil, paramsEncoding: URLEncoding.default) { (jsonData, isConnection, error) in
            if !isConnection {
                completion([], "No internet connection")
                return
            }
            
            var allCameras: [CameraModel] = []
            
            let jsonNotes = jsonData?.arrayObject
            
            if jsonNotes != nil {
                for item in jsonNotes! {
                    if let camera = CameraModel(map: Map(mappingType: .fromJSON, JSON: item as! [String : Any])) {
                        allCameras.append(camera)
                        
                    }
                }
                completion(allCameras, nil)
            } else {
                completion([], "Ошибка загрузки")
            }
        }
    }
}


    

