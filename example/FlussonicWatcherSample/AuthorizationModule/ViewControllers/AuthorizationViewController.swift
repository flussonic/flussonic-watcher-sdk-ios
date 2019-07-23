//
//  AuthorizationViewController.swift
//  ErlyVideo
//
//  Created by Dmitry on 18/06/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit


class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorView.isHidden = true
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    // hide keyboard after tap on  done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        var txtAfterUpdate:NSString = text as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        if String(txtAfterUpdate).count > 20 {
            
            return false
        }
        return true
    }
    
    func checkOperation() {
        if loginTextField.text == "" && passwordTextField.text == "" {
            CustomActivity.shared.hide()
            self.errorView.isHidden = false
            self.errorLabel.text = "Не удалось авторизоваться. Проверьте введенные данные."
        } else {
            self.errorView.isHidden = true
            self.goAuth()
        }
    }
    
    func goAuth() {
        AuthorizationService.shared.requestAuthorization(login: loginTextField.text ?? "", password: passwordTextField.text ?? "") { (error) in
            CustomActivity.shared.hide()
            if error == nil {
                CameraRouting.showCameraListScreen(fromVC: self)
            } else {
                self.errorView.isHidden = false
                self.errorLabel.text = "Ошибка авторизации: \(error!)"
            }
        }
    }
    
    
    //MARK: - Navigation
    @IBAction func confirmButtonTouched(_ sender: Any) {
        CustomActivity.shared.show(uiView: self.view)
        self.checkOperation()
    }
    
    
}

