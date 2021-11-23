//
//  StreamStatusItem.swift
//  Domain
//
//  Created by Garafutdinov Ravil on 24/07/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation

class StreamStatusItem: NSObject {
    public private(set) var bitrate: Int64?
    public private(set) var alive: Bool = false
    public private(set) var server: String = ""
    public private(set) var httpPort: Int32?
    public private(set) var httpsPort: Int32?

    public init(with jsonItem: [String: Any]) {
        super.init()

        guard !jsonItem.isEmpty else { return }

        bitrate = jsonItem["bitrate"] as? Int64
        alive = jsonItem["alive"] as? Bool ?? false
        server = jsonItem["server"] as? String ?? ""
        httpPort = jsonItem["http_port"] as? Int32
        httpsPort = jsonItem["https_port"] as? Int32
    }
}
