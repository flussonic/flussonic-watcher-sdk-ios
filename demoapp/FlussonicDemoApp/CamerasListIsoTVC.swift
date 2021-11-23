//
//  CamerasListIsoTVC.swift
//  FlussonicIso
//
//  Created by Garafutdinov Ravil on 10/12/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import RxSwift
import FlussonicSDK

class CamerasListIsoTVC: UITableViewController, CameraListIsoTVCellAlertDelegate {

    let UPDATE_TIME_SECONDS = 5

    public var baseUrl: String = ""
    public var sessionToken: String = ""
    public var camerasList: [CameraItem] = []

    var allowDownload = true
    var startPosition = false
    var enableUpdating: Bool = false {
        didSet {
            if enableUpdating {
                startUpdatePreviewTimer()
            } else {
                stopUpdatePreviewTimer()
            }
        }
    }

    var startPositionDate: Date?
    var updateDisposeBag: DisposeBag?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.isUserInteractionEnabled = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return camerasList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CameraListIsoTVCell", for: indexPath) as? CameraListIsoTVCell

        cell?.baseUrl = baseUrl
        cell?.session = sessionToken
        cell?.cameraItem = camerasList[indexPath.row]
        cell?.alertDelegate = self

        return cell ?? CameraListIsoTVCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cameraItem = camerasList[indexPath.row]
        //        if cameraItem.isAlive() {
        tableView.isUserInteractionEnabled = false
        performSegue(withIdentifier: "ListToPlayerSegue", sender: cameraItem)
        //        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ListToPlayerSegue":
            guard let destinationVC = segue.destination as? PlayerIsoViewController,
                  let item = sender as? CameraItem
            else { break }

            destinationVC.cameraItem = item
            destinationVC.baseUrl = baseUrl
            destinationVC.sessionToken = sessionToken
            destinationVC.allowDownload = allowDownload
            destinationVC.startPosition = startPosition
            destinationVC.startPositionDate = startPositionDate

        default: break
        }
    }

    // MARK: - menu
    @IBAction func onMenuTouch(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Preview update: \(enableUpdating)", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.enableUpdating = !self.enableUpdating
        }))

        actionSheet.addAction(UIAlertAction(title: "Start position: \(startPosition)", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.startPosition = !self.startPosition
        }))

        var dateString = ""
        if startPositionDate == nil {
            dateString = "не установлено"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "EN_US_POSIX")
            dateFormatter.dateFormat = "dd.MM.YY - HH:mm:ss"

            dateString = dateFormatter.string(from: startPositionDate!)
        }

        actionSheet.addAction(UIAlertAction(title: "Start position date: \(dateString)", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }

            guard let controller = DateTimeViewController.instance()
            else { return }

            controller.modalPresentationStyle = .overCurrentContext

            controller.onCompletion = { [weak self] (date) in
                guard let `self` = self,
                      let newDate = date // тут можно обработать Cancel
                else { return }

                self.startPositionDate = newDate
            }

            self.present(controller, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Allow download: \(allowDownload)", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            self.allowDownload = !self.allowDownload
        }))

        actionSheet.addAction(UIAlertAction(title: "Clean Cache", style: .default, handler: { _ in
            let preview = PreviewMp4View()
            preview.cleanCache()
        }))

        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func startUpdatePreviewTimer() {
        updateDisposeBag = DisposeBag()
        // раз в секунду обновляем инфу о камере и вызываем updateVisibleCells
        Observable<Int>.interval(.seconds(UPDATE_TIME_SECONDS), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] key in
                self?.updateVisibleCells(time: key)
            })
            .disposed(by: updateDisposeBag!)
    }

    func stopUpdatePreviewTimer() {
        updateDisposeBag = nil
    }

    private func updateVisibleCells(time: Int) {
        let newCacheKey = "new cacheKey is \(time)"
        for tableCell in tableView.visibleCells {
            guard let cell = tableCell as? CameraListIsoTVCell else { continue }
            DispatchQueue.asyncInMainQueue(self, { (_) in
                cell.updateCacheKey(key: newCacheKey)
            })
        }
    }
}
