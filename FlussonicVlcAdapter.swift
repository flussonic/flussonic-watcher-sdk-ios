//
//  FlussonicVlcAdapter.swift
//

import UIKit
import DynamicMobileVLCKit
import FlussonicSDK

class FlussonicVlcAdapter: NSObject, FlussonicPlayerAdapterProtocol, VLCMediaPlayerDelegate {

    private var player: VLCMediaPlayer?

    private var timeObservation: NSKeyValueObservation?

    override init() {
        super.init()
        player = VLCMediaPlayer()
        player!.delegate = self
        setupTimeObservation()
    }

    deinit {
        timeObservation?.invalidate()
    }

    // MARK: - FlussonicPlayerAdapterProtocol
    weak var delegate: FlussonicPlayerAdapterDelegate?

    var drawable: UIView? {
        get {
            return (player?.drawable as? UIView)
        }
        set {
            player?.drawable = newValue
        }
    }

    var rate: Float {
        get {
            return player?.rate ?? 1.0
        }
        set {
            player?.rate = newValue
        }
    }

    var videoSize: CGSize {
        return player!.videoSize
    }

    var hasVideoOut: Bool {
        return player?.hasVideoOut ?? false
    }

    var timeValue: Double {
        guard let plr = player,
            let time = plr.time,
            time.value != nil else { return -0.001 }
        return Double(truncating: time.value)
    }

    var mediaUrl: URL? {
        get {
            guard let plr = player, plr.media != nil else { return nil }
            return plr.media.url
        }
        set {
            stop()
            player?.media = nil
            guard newValue != nil else { return }
            fixScaleToFill()
            player?.media = VLCMedia(url: newValue!)
            player?.play()
        }
    }

    var audioIsMuted: Bool {
        get {
            guard let plr = player else { return true }
            return plr.currentAudioTrackIndex < 0
        }
        set {
            guard player != nil else { return }
            disableAudioTrack(audioDisabled: newValue)
        }
    }

    func disableAudioTrack(audioDisabled: Bool) {
        guard let plr = player else { return }
        guard let idx = FlussonicVLCHelpers.calcAudioTrackIndex(
            audioDisabled: audioDisabled,
            currentAudioTrackIndex: plr.currentAudioTrackIndex,
            audioTrackIndexes: plr.audioTrackIndexes) else { return }
        plr.currentAudioTrackIndex = idx
    }

    func fixScaleToFill() {
        DispatchQueue.main.async {
            guard self.drawable != nil,
                self.player != nil
                else {
                    return
            }
            let aspectRatio = FlussonicVLCHelpers.calcAspectRatio(drawableView: self.drawable)
            self.player?.videoAspectRatio = aspectRatio
        }
    }

    var lastSnapshot: UIImage? {
        return player?.lastSnapshot
    }

    var state: FlussonicPlayerAdapterState {
        guard let plr = player,
            let pState = FlussonicPlayerAdapterState(rawValue: plr.state.rawValue)
            else {
                return .stopped
        }
        return  pState
    }

    var mediaState: FlussonicPlayerAdapterMediaState {
        guard let plr = player, plr.media != nil else { return .nothingSpecial }
        return FlussonicPlayerAdapterMediaState(rawValue: plr.media.state.rawValue) ?? .nothingSpecial
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        guard let plr = player,
            state != .stopped,
            mediaState != .nothingSpecial
            else {
                return
        }
        plr.stop()
    }

    func saveVideoSnapshot(at path: String, withWidth width: Int32, andHeight height: Int32) {
        player?.saveVideoSnapshot(at: path, withWidth: width, andHeight: height)
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

// MARK: Time Observation
private extension FlussonicVlcAdapter {
    func setupTimeObservation() {
        guard let plr = player else {
            return
        }
        timeObservation = plr.observe(\VLCMediaPlayer.time, options: [.new, .initial, .old], changeHandler: { [weak self] (_, kind) in
            guard let `self` = self,
                let values = kind.newValue?.both(with: kind.oldValue.joining()),
                values.a.value != nil, values.b.value != nil else { return }
            self.delegate?.mediaPlayerTimeChanged(oldTimeValue: values.b.value.doubleValue, newTimeValue: values.a.value.doubleValue)
        })
    }
}
