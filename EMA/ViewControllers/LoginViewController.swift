//
//  LoginViewController.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import UIKit
import RxSwift
import ParkedTextField
import Spring

class LoginViewController: UIViewController {
  
  // MARK: - Properties -
  
  @IBOutlet weak var loginSpringView: SpringView!
  @IBOutlet weak var emailParkedTextField: ParkedTextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  var viewModel: LoginViewModel!
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindView()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if let _ = NSUserDefaults.standardUserDefaults().objectForKey("login") {
      self.performSegueWithIdentifier("GoToHome", sender: self)
    }
  }
  
  // MARK: - User interface and interaction -
  
  func bindView() {
    let emailTextFieldValidation    = emailParkedTextField.rx_text.map { _ in !self.emailParkedTextField.typedText.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).isEmpty }
    let passwordTextFieldValidation = passwordTextField.rx_text.map(emptyValidation)
    let enableLoginButton           = Observable.combineLatest(emailTextFieldValidation, passwordTextFieldValidation) { email, password in
      return email && password
    }
    
    enableLoginButton
      .asObservable()
      .doOnNext { enabled in
        self.loginButton.backgroundColor = enabled ? UIColor.minesAlesColor() : UIColor.lightGrayColor()
      }
      .bindTo(loginButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    loginButton
      .rx_tap
      .asDriver()
      .driveNext {
       
        self.view.endEditing(true)
        AWLoader.show()
       
        let login = self.emailParkedTextField.typedText
        
        self.viewModel.login(login, password: self.passwordTextField.text!) { response, error in
          
            guard error == nil else {
              self.presentViewController(UIAlertController.genericNetworkErrorAlertController, animated: true, completion: nil)
              AWLoader.hide()
              return
            }
            
            guard let profile = response?.profile, token = response?.token where response?.success == true else {
              self.loginSpringView.shake()
              AWLoader.hide()
              return
            }
            
            // Save profile info
            NSUserDefaults.standardUserDefaults().saveProfile(profile)
          NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
            self.performSegueWithIdentifier("GoToHome", sender: self)
            
          }
      }.addDisposableTo(disposeBag)
  }
}
