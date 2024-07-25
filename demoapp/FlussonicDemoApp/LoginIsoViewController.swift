//
//  LoginIsoViewController.swift
//  FlussonicIso
//
//  Created by Garafutdinov Ravil on 07/12/2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import FlussonicSDK

class LoginIsoViewController: UIViewController {

    @IBOutlet weak var cameraServerTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var camerasListButton: UIButton!
    @IBOutlet weak var mosaicsListButton: UIButton!

    private var camerasList: [CameraItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        onLoginTouch()
    }

    @IBAction func onLoginTouch() {
        guard let server = cameraServerTextField.text,
              !server.isEmpty,
              let login = loginTextField.text,
              !login.isEmpty,
              let password = pwTextField.text,
              !password.isEmpty
        else { return }

        let url = URL(string: "\(server)/vsaas/api/v2/auth/login")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let parameterDictionary = ["login": login, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            else { return }

            DispatchQueue.main.async {
                self?.tokenTextField.text = json["session"] as? String
            }
        }.resume()
    }

    @IBAction func onCamerasTouch() {
        guard let server = cameraServerTextField.text,
              !server.isEmpty,
              let login = loginTextField.text,
              !login.isEmpty,
              let password = pwTextField.text,
              !password.isEmpty,
              let baseUrlString = cameraServerTextField.text,
              !baseUrlString.isEmpty,
              let baseUrl = URL(string: baseUrlString),
              let token = tokenTextField.text,
              !token.isEmpty
        else { return }

        let url = URL(string: "\(server)/vsaas/api/v2/cameras")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Vsaas-Session")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil,
                  let jsonOpt = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                  let json: [[String: Any]] = jsonOpt as? [[String: Any]]
            else { return }
            let cameraDecoder = JSONDecoder()
            for jsonItem in json {
                guard let data = try? JSONSerialization.data(withJSONObject: jsonItem, options: []),
                      var cameraItem = try? cameraDecoder.decode(CameraItem.self, from: data) else { continue }
                cameraItem.setWatcherUrl(url: baseUrl.absoluteString)
                self?.camerasList.append(cameraItem)
            }

            DispatchQueue.main.async {
                guard let `self` = self else { return }

                self.performSegue(withIdentifier: "loginToCamerasListSegue", sender: self)
            }
        }.resume()
    }

    @IBAction func onMosaicsTouch() {
        guard let server = cameraServerTextField.text,
              !server.isEmpty,
              let login = loginTextField.text,
              !login.isEmpty,
              let password = pwTextField.text,
              !password.isEmpty,
              let baseUrlString = cameraServerTextField.text,
              !baseUrlString.isEmpty,
              let baseUrl = URL(string: baseUrlString),
              let token = tokenTextField.text,
              !token.isEmpty
        else { return }

        let url = URL(string: "\(server)/vsaas/api/v2/cameras")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Vsaas-Session")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil,
                  let jsonOpt = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                  let json: [[String: Any]] = jsonOpt as? [[String: Any]]
            else { return }

            let cameraDecoder = JSONDecoder()
            for jsonItem in json {
                guard let data = try? JSONSerialization.data(withJSONObject: jsonItem, options: []),
                      var cameraItem = try? cameraDecoder.decode(CameraItem.self, from: data) else { continue }
                cameraItem.setWatcherUrl(url: baseUrl.absoluteString)
                self?.camerasList.append(cameraItem)
            }

            DispatchQueue.main.async {
                guard let `self` = self else { return }

                self.performSegue(withIdentifier: "loginToMosaicsListSegue", sender: self)
            }
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "loginToCamerasListSegue":
            guard let destinationVC = segue.destination as? CamerasListIsoTVC,
                  let baseUrl = cameraServerTextField.text,
                  let token = tokenTextField.text
            else { return }

            destinationVC.camerasList = camerasList
            destinationVC.baseUrl = baseUrl
            destinationVC.sessionToken = token
        case "loginToMosaicsListSegue":
            guard let destinationVC = segue.destination as? MosaicListIsoTVC,
                  let baseUrl = cameraServerTextField.text,
                  let token = tokenTextField.text
            else { return }

            destinationVC.baseUrl = baseUrl
            destinationVC.sessionToken = token
            destinationVC.camerasList = camerasList
        default:
            break
        }
    }

}
