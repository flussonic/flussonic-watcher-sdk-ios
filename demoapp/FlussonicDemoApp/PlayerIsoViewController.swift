//
//  PlayerIsoViewController.swift
//  FlussonicIso
//
//  Created by Garafutdinov Ravil on 21/12/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import FlussonicSDK

class PlayerIsoViewController: UIViewController,
                               FlussonicBufferingListener,
                               FlussonicDownloadRequestListener,
                               FlussonicWatcherDelegateProtocol,
                               FlussonicUpdateProgressEventListener,
                               FlussonicPlayerErrorListener,
                               FlussonicQualityListener {

    @IBOutlet weak var flussonicView: FlussonicWatcherView!

    private let adapter = FlussonicVlcAdapter()

    public var baseUrl: String = ""
    public var sessionToken: String = ""
    public var cameraItem: CameraItem?

    public var allowDownload = true {
        didSet {
            flussonicView?.allowDownload = allowDownload
        }
    }

    public var startPosition = false
    public var startPositionDate: Date? {
        didSet {
            flussonicView?.startPositionDate = startPositionDate
        }
    }

    private var notification: NSObjectProtocol?

    private var audioDisabled: Bool = false

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func showAlert(title ttl: String, message msg: String) {
        let alert = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let cameraItem: CameraItem = cameraItem else { return }

        // принудительный пoворот
        UIViewController.attemptRotationToDeviceOrientation()

        // отрубим свайп назад
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        navigationItem.title = cameraItem.title

        // настройка flussonicView
        flussonicView.currentTheme = FlussonicWatcherTheme(colors: CustomFlussonicTheme.toDict())
        flussonicView.delegate = self
        flussonicView.alertDelegate = self
        flussonicView.setQualityListener(qualityListener: self)
        flussonicView.updateProgressEventListener = self
        flussonicView.bufferingListener = self
        flussonicView.downloadRequestListener = self
        flussonicView.playerErrorListener = self

        flussonicView.videoQuality = .SD
        flussonicView.setHideToolbarInPortrait(shouldHideToolbar: true)
        flussonicView.setShowDebugInfo(newValue: true)
        flussonicView.setTimelineMarkersV2(withTimelineMarkersV2: true)

        let startDateOrNil = startPosition ? startPositionDate : nil
        let from = startDateOrNil?.timeIntervalSince1970
        let cameraUrl = cameraItem.cameraUrl(withToken: sessionToken, from: from)
        if cameraUrl != nil {
            // proto://       token               @base serverurl/     camera name    ?from (opt) unixtime
            // https://abcabcNqzazQHe5nSjFUxxxxxxx@cloud.vsaas.io/camera.32-2fac123abc?from=1545660274
            //
            // if from is specified, player will try to start an archive from that point
            // if not, will play live
            flussonicView.configure(withUrl: cameraUrl!, playerAdapter: adapter)
        }

        // возможность скачивания фрагментов и начальная точка
        flussonicView.allowDownload = allowDownload
        flussonicView.startPositionDate = startDateOrNil

        // если качество сети плохое, при трех ошибках проиигрывания ухудшаем качество
        flussonicView.setNetworkQualityThresholdCount(count: 3)

        // vlcMediaPlayer оповещает о скриншотах через анонимное событие
        // поэтому обработчик скриншотов общий
        flussonicView.screenshotCaptured = { [weak self] image in
            guard let `self` = self else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }

        // плеер останавливает проигрыш потока в фоне, нужно снова его запускать при просыпании
        notification = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil, queue: .main) { [weak self] _ in
            guard let `self` = self else { return }

            self.flussonicView.resume()
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlert(title: "Ошибка", message: "Для сохранения файла разрешите доступ приложения к галерее в системных настройках.")
        } else {
            showAlert(title: "", message: "Скриншот добавлен в галерею.")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        flussonicView.pause()

        // включим свайп назад
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    deinit {
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        }
    }

    @IBAction func onMenuTouch(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // screenshot
        actionSheet.addAction(UIAlertAction(title: "Screenshot", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            self.flussonicView.captureScreenshot(destUrl: URL(fileURLWithPath: "\(documentsPath)/screenshot.jpg"))
        }))
        let muteStr = audioDisabled ? "Unmute" : "Mute"
        actionSheet.addAction(UIAlertAction(title: muteStr, style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.audioDisabled = !self.audioDisabled
            self.flussonicView.disableAudio(audioDisabled: self.audioDisabled)
        }))

        // pause
        actionSheet.addAction(UIAlertAction(title: "Pause", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.flussonicView.pause()
        }))

        // resume
        actionSheet.addAction(UIAlertAction(title: "Resume", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.flussonicView.resume()
        }))

        // seek
        actionSheet.addAction(UIAlertAction(title: "Seek", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }

            guard let controller = DateTimeViewController.instance()
            else { return }

            controller.modalPresentationStyle = .overCurrentContext

            controller.onCompletion = { [weak self] (date) in
                guard let `self` = self,
                      let newDate = date // тут можно обработать Cancel
                else { return }

                self.flussonicView.seek(seconds: newDate.timeIntervalSince1970)
            }

            self.present(controller, animated: true, completion: nil)
        }))

        // allow download
        actionSheet.addAction(UIAlertAction(title: "Allow download: \(allowDownload)", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.allowDownload = !self.allowDownload
        }))

        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - FlussonicWatcherDelegateProtocol
    func expandToolbar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func collapseToolbar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func showToolbar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func hideToolbar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - FlussonicDownloadRequestListener
    func onDownloadRequest(from: Int64, to: Int64) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "EN_US_POSIX")
        dateFormatter.dateFormat = "dd.MM.YY - HH:mm:ss"

        let fromDate = Date(timeIntervalSince1970: Double(from))
        let toDate = Date(timeIntervalSince1970: Double(to))

        let alert = UIAlertController(title: "Запрос на скачивание отрывка",
                                      message: "С: \(dateFormatter.string(from: fromDate))\nпо: \(dateFormatter.string(from: toDate))",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - FlussonicBufferingListener
    func onBufferingStart() {

    }

    func onBufferingStop() {
        print("buffering stopped \ncurrentTrack: \(String(describing: flussonicView?.getCurrentStream()?.trackId))")

    }

    // MARK: - FlussonicUpdateProgressEventListener
    func onUpdateProgress(event: ProgressEvent) {
        let formattedTime = Date(timeIntervalSince1970: event.currentUtcInSeconds).debugDescription
        //        print("progress: \(formattedTime) track: \(String(describing: flussonicView?.getCurrentStream()?.trackId)) isMuted: \(event.audioDisabled)")
    }

    func onPlayerError(code: String, message: String, url: String) {
        print("onPlayerError called \nwith code: \(code)\n with url: \(url) \nwith message \(message)")
    }

    func onQualityChanged(quality: FlussonicVideoQuality) {
        let qStr: String = quality.stringValue
        let q1 = FlussonicVideoQuality(stringValue: "AUTO")
        print("onQualityChanged \(qStr) \(String(describing: q1))")
    }
}
