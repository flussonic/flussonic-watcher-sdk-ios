//
//  StreamStatusModel.swift
//  ErlyVideo
//
//  Created by Dmitry on 20/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import ObjectMapper

class StreamStatusModel: NSObject, Mappable {
    
    var alive = 0
    var bitrate = 0
    var http_port = 0
    var https_port = 0
    var lifetime = 0
    var rtmp_port = 0
    var rtsp_port = 0
    var server = ""
    var source_error: String?
        
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
        self.mapping(map:map)
    }
    
    func mapping(map: Map) {
        alive            <- map["alive"]
        bitrate          <- map["bitrate"]
        http_port        <- map["http_port"]
        https_port       <- map["https_port"]
        lifetime         <- map["lifetime"]
        rtmp_port        <- map["rtmp_port"]
        rtsp_port        <- map["rtsp_port"]
        server           <- map["server"]
        source_error     <- map["source_error"]
    }
}
