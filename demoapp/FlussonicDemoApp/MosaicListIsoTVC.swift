//
//  MosaicListIsoTVC.swift
//  FlussonicIso
//
//  Created by otvazhniy on 06.05.2020.
//  Copyright © 2020 Erlyvideo. All rights reserved.
//

import Foundation
import FlussonicSDK

class MosaicListIsoTVC: UITableViewController, MosaicListIsoTVCellAlertDelegate {
    public var baseUrl: String?
    public var sessionToken: String?
    public var camerasList: [CameraItem] = []

    var allowDownload = true
    var startPosition = false
    var startPositionDate: Date?

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MosaicListIsoTVCell", for: indexPath) as? MosaicListIsoTVCell

        cell?.session = sessionToken
        cell?.cameraItem = camerasList[indexPath.row]
        cell?.alertDelegate = self

        return cell ?? MosaicListIsoTVCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cameraItem = camerasList[indexPath.row]
        // enable opening broken camera for playing archive when camera offline
        if startPosition || cameraItem.isAlive() {
            tableView.isUserInteractionEnabled = false
            performSegue(withIdentifier: "ListToPlayerSegue", sender: cameraItem)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ListToPlayerSegue":
            guard let destinationVC = segue.destination as? PlayerIsoViewController,
                  let sessionToken = sessionToken,
                  let baseUrl = baseUrl,
                  let item = sender as? CameraItem
            else { break }

            destinationVC.baseUrl = baseUrl
            destinationVC.sessionToken = sessionToken
            destinationVC.cameraItem = item
            destinationVC.allowDownload = allowDownload
            destinationVC.startPosition = startPosition
            destinationVC.startPositionDate = startPositionDate

        default: break
        }
    }

    // MARK: - menu
    @IBAction func onMenuTouch(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
