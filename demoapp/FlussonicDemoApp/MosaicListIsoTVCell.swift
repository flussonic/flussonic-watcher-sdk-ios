//
//  MosaicListTVCell.swift
//  FlussonicIso
//
//  Created by otvazhniy on 06.05.2020.
//  Copyright © 2020 Erlyvideo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FlussonicSDK

protocol MosaicListIsoTVCellAlertDelegate: AnyObject {
    func showAlert(title: String, message: String)
}

class MosaicListIsoTVCell: UITableViewCell, FlussonicMosaicDelegateProtocol,
                           FlussonicUpdateProgressEventListener,
                           FlussonicBufferingListener,
                           FlussonicPlayerErrorListener {
    func onControlsVisible() {
        print("onControlsVisible caled")
    }

    func onControlsHidden() {
        print("onControlsHidden caled")
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var flussonicMosaicView: FlussonicMosaicView!
    @IBOutlet weak var activeView: UIView!
    private var adapter: FlussonicPlayerAdapterProtocol?

    private var notification: NSObjectProtocol?

    public weak var alertDelegate: MosaicListIsoTVCellAlertDelegate?

    public var session: String?

    public var cameraItem: CameraItem? {
        didSet {
            guard let item = cameraItem else { return }
            titleLabel.text = item.title
            statusLabel.text = (item.isAlive()) ? "Active" : "Inactive"
            activeView.backgroundColor = (item.isAlive()) ? .green : .red
            guard item.isAlive() == true else { return }
            adapter = FlussonicVlcAdapter()
            flussonicMosaicView.delegate = self
            flussonicMosaicView.setBufferingListener(bufferingListener: self)
            flussonicMosaicView.setUpdateProgressEventListener(updateProgressEventListener: self)
            flussonicMosaicView.setPlayerErrorListener(playerErrorListener: self)
            guard let session = session,
                  let url = item.cameraUrl(withToken: session, from: nil) else { return }
            flussonicMosaicView.configure(withUrl: url, playerAdapter: adapter)
            flussonicMosaicView.disableAudio(audioDisabled: false)

            flussonicMosaicView.setNetworkQualityThresholdCount(count: 1)
        }
    }

    override func prepareForReuse() {
        print("prepare for reuse called")
        flussonicMosaicView.pause()
        adapter?.stop()
    }

    deinit {
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        }
        flussonicMosaicView.pause()
    }

    // MARK: - FlussonicUpdateProgressEventListener
    func onUpdateProgress(event: ProgressEvent) {
        if event.playbackStatus == .PLAYING {
            flussonicMosaicView.disableAudio(audioDisabled: true)
        }
        print("progress status \(event.playbackStatusString) isMuted \(event.audioDisabled)")
    }

    // MARK: - FlussonicBufferingListener
    func onBufferingStart() {
        print("onBufferingStart")
    }

    func onBufferingStop() {
        print("onBufferingStop")
    }

    // MARK: - FlussonicPlayerErrorListener
    func onPlayerError(code: String, message: String, url: String) {
        print("onPlayerError called \nwith code: \(code)\n with url: \(url) \nwith message \(message)")
        //        alertDelegate?.showAlert(title: "Error!", message: "\(cameraItem?.name ?? "unknown camera") got error with code \(code), \ndescription \(message)")
    }
}
