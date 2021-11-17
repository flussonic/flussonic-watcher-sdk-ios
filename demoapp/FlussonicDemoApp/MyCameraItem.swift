//
//  CameraItem.swift
//  Domain
//
//  Created by Garafutdinov Ravil on 19/12/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation
import FlussonicSDK

class MyCameraItem: NSObject {

    public private(set) var token: String = ""
    public private(set) var name: String = ""
    public private(set) var title: String?
    public private(set) var streamStatus: StreamStatusItem = StreamStatusItem(with: [:])
    public private(set) var baseUrl: String = ""

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case title = "title"
        case streamStatus = "stream_status"
    }

    init(with jsonItem: [String: Any], baseUrl urlString: String) {
        super.init()
        if let playbackConfig: [String: String] = (jsonItem["playback_config"] as? [String: String]) {
            token = playbackConfig["token"] ?? ""
        }
        name = jsonItem["name"] as? String ?? ""
        baseUrl = urlString

        streamStatus = StreamStatusItem.init(with: (jsonItem["stream_status"] as? [String: Any])!)
    }

    public func isAlive() -> Bool {
        return streamStatus.alive
            && streamStatus.bitrate != nil
            && currentPort() != nil
            && !name.isEmpty
            && !streamStatus.server.isEmpty
            && !token.isEmpty
    }

    public func useHttps() -> Bool {
        return streamStatus.httpsPort != nil
    }

    public func currentProtocol() -> String {
        return useHttps() ? "https" : "http"
    }

    public func currentPort() -> Int32? {
        return useHttps() ? streamStatus.httpsPort : streamStatus.httpPort
    }

    public func previewUrlWithUserSession(_ server: String) -> URL? {
        return URL(string: "\(server)/\(name)")
    }

    public func previewUrlWithCameraToken() -> URL? {

        let port = (currentPort() != nil) ? ":\(currentPort()!)" : ""
        let urlString = "\(currentProtocol())://\(streamStatus.server)\(port)/\(name)/preview.mp4?token=\(token)"

        return URL(string: urlString)
    }

    public func cameraUrl(withToken token: String, from f: Double?) -> URL? {
        let port = (currentPort() != nil) ? ":\(currentPort()!)" : ""
        print("current port: \(port)")
        let from = (f != nil) ? "?from=\(f!)" : ""
        let urlString = "\(currentProtocol())://\(token)@\(baseUrl)/\(name)\(from)"

        return URL(string: urlString)
    }
}
