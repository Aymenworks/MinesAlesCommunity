//
//  LoginViewModel.swift
//  EMA
//
//  Created by Rebouh Aymen on 26/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct LoginViewModel {
  
  // MARK: - Properties -
  
  let service: LoginAPI
  
  // MARK: - Lifecycle -
  
  init(service: LoginAPI) {
    self.service = service
  }

  // MARK: - Network -
  
  func login(login: String, password: String, completionBlock: (LoginResponse?, NSError?) -> ()) {
    self.service.requestLoginWithLogin(login, password: password) { response, error in
      completionBlock(response, error)
    }
  }
  
}