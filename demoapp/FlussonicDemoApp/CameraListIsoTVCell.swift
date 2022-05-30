//
//  CameraListIsoTVCell.swift
//  FlussonicIso
//
//  Created by Garafutdinov Ravil on 10/12/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import FlussonicSDK

protocol CameraListIsoTVCellAlertDelegate: AnyObject {
    func showAlert(title: String, message: String)
}

class CameraListIsoTVCell: UITableViewCell, PreviewMp4ViewStatusListener {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var previewView: PreviewMp4View!
    @IBOutlet weak var activeView: UIView!

    public weak var alertDelegate: CameraListIsoTVCellAlertDelegate?
    public var session: String = ""
    public var baseUrl: String = ""

    public var cameraItem: CameraItem? {
        didSet {
            guard let `cameraItem` = cameraItem else { return  }

            titleLabel.text = cameraItem.title
            let alive = cameraItem.isAlive()
            statusLabel.text = (alive) ? "Active" : "Inactive"
            activeView.backgroundColor = (alive) ? .green : .red

            // основной вариант с токеном камеры
            print("cameraItem didSet with url \(titleLabel.text)")
            guard let url = cameraItem.cameraUrl(withToken: session, from: nil) else { return }
            print("cameraItem didSet with url \(url.absoluteString)")
            previewView.configure(withUrl: url, cacheKey: url.absoluteString)
            previewView.statusListener = self
        }
    }

    override func prepareForReuse() {
        previewView.reset()
    }

    func onStatusChanged(_ status: Int8, _ code: String, _ message: String) {
        if status == PreviewMp4StatusEnum.error.rawValue {
            DispatchQueue.main.async {
            }
        }
    }

    func updateCacheKey(key: String) {
        previewView.setCacheKey(to: key)
    }
}
