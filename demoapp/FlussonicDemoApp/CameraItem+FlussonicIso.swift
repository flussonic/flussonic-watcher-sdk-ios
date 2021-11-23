//
//  CameraItem+FlussonicIso.swift
//  FlussonicIso
//
//  Created by otvazhniy on 13.01.2021.
//  Copyright © 2021 Erlyvideo. All rights reserved.
//

import Foundation
import FlussonicSDK

extension CameraItem {
    func previewUrlWithCameraToken(from time: Double?) -> URL? {
        var result = URLComponents()
        result.scheme = currentProtocol()
        result.host = streamStatus.server
        result.port = Int(currentPort())
        result.path = "/\(name)/preview.mp4"
        var urlQueryItems = [ URLQueryItem(name: "token", value: playbackConfig.token) ]
        if time != nil {
            urlQueryItems.append(URLQueryItem(name: "from", value: "\(time!)"))
        }
        result.queryItems = urlQueryItems
        return result.url
    }
}
