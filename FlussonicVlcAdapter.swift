//
//  FlussonicVlcAdapter.swift
//

import UIKit
import DynamicMobileVLCKit

class FlussonicVlcAdapter: NSObject, FlussonicPlayerAdapterProtocol, VLCMediaPlayerDelegate {
    
    private var player: VLCMediaPlayer!
    
    private var timeObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        
        player = VLCMediaPlayer()
        player.delegate = self
        setupTimeObservation()
    }
    
    deinit {
        timeObservation?.invalidate()
    }

    // MARK: - FlussonicPlayerAdapterProtocol
    var delegate: FlussonicPlayerAdapterDelegate?
    
    var drawable: Any? {
        get {
            return player.drawable
        }
        set {
            player.drawable = newValue
        }
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        set {
            player.rate = newValue
        }
    }
    
    var videoSize: CGSize {
        return player.videoSize
    }
    
    var hasVideoOut: Bool {
        return player.hasVideoOut
    }
    
    var timeValue: Double {
        guard player.time != nil else { return 0 }
        return player.time.value.doubleValue
    }
    
    var mediaUrl: URL? {
        get {
            guard player.media != nil else { return nil }
            return player.media.url
        }
        set {
            player.stop()
            player.media = nil
            
            guard newValue != nil else { return }
            
            player.media = VLCMedia(url: newValue!)
            player.play()
        }
    }
    
    var audioIsMuted: Bool {
        get {
            guard player.audio != nil else { return true } // no audio = no audio
            return player.audio.isMuted
        }
        set {
            guard player.audio != nil else { return }
            player.audio.isMuted = newValue
        }
    }
    
    var lastSnapshot: UIImage? {
        return player.lastSnapshot
    }
    
    var state: FlussonicPlayerAdapterState {
        return FlussonicPlayerAdapterState(rawValue: player.state.rawValue) ?? .stopped
    }
    
    var mediaState: FlussonicPlayerAdapterMediaState {
        guard player.media != nil else { return .nothingSpecial }
        return FlussonicPlayerAdapterMediaState(rawValue: player.media.state.rawValue) ?? .nothingSpecial
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.stop()
    }
    
    func saveVideoSnapshot(at path: String, withWidth width: Int32, andHeight height: Int32) {
        player.saveVideoSnapshot(at: path, withWidth: width, andHeight: height)
    }
    
    // MARK: - VLCMediaPlayerDelegate
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        delegate?.mediaPlayerStateChanged(Notification(name: Notification.Name("mediaPlayerStateChanged"), object: self, userInfo: nil))
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        delegate?.mediaPlayerTimeChanged(Notification(name: Notification.Name("mediaPlayerTimeChanged"), object: self, userInfo: nil))
    }
    
    func mediaPlayerSnapshot(_ aNotification: Notification!) {
        delegate?.mediaPlayerSnapshot(Notification(name: Notification.Name("mediaPlayerSnapshot"), object: self, userInfo: nil))
    }
    
}

private extension FlussonicVlcAdapter {
    func setupTimeObservation() {
        timeObservation = player.observe(\VLCMediaPlayer.time, options: [.new, .initial, .old], changeHandler: { [weak self] (_, kind) in
            guard let `self` = self,
                let values = kind.newValue?.both(with: kind.oldValue.joining()),
                values.a.value != nil, values.b.value != nil else { return }
            self.delegate?.mediaPlayerTimeChanged(oldTimeValue: values.b.value.doubleValue, newTimeValue: values.a.value.doubleValue)
        })
    }
}
