//
//  CameraModel.swift
//  ErlyVideo
//
//  Created by Dmitry on 19/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import ObjectMapper

let host = "cloud.vsaas.io"

class CameraModel: NSObject, Mappable {
    
    var name = ""
    var title = ""
    var token = ""
    var lastEventTime: UInt32 = 0
    var isOnline = false
    var streamStatus = StreamStatusModel()
    
    var urlForPlayer = ""
    var urlForPreview = ""

    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
        self.mapping(map:map)
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        title           <- map["title"]
        isOnline        <- map["stream_status.alive"]
        streamStatus    <- map["stream_status"]
        lastEventTime   <- map["last_event_time"]
        token           <- map["playback_config.token"]

        urlForPlayer = "https://\(AuthorizationService.shared.session)@\(host)/\(name)?from=\(lastEventTime)/"
        print(urlForPlayer)
        urlForPreview = "https://\(host):\(streamStatus.https_port)/\(name)/preview.mp4?token=\(token)"
        
    }
}

