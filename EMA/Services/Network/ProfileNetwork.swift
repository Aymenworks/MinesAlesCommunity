//
//  ProfileNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo


struct ProfileNetwork: ProfileAPI {
  func requestAllCreatedItems(userId: Int, completionBlock: (response: ProfileResponse?, error: NSError?) -> ()) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/myPublications/\(userId)", parameters: ["token": NSUserDefaults.standardUserDefaults().token])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<ProfileResponse> = decode(json), let response = decoded.value {
          completionBlock(response: response, error: nil)
        } else {
          completionBlock(response: nil, error: response.result.error)
        }
    }
  }
  
  func requestDelete(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) {
    let parameters: [String: AnyObject] = ["token": NSUserDefaults.standardUserDefaults().token, "id_user": NSUserDefaults.standardUserDefaults().id]
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/\(item.api)/\(item.idItem)", parameters: parameters)
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<SuccessResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: response.result.error)
        }
    }
  }
  
  func requestUpdate(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) {
    var parameters = item.updateParameters
    parameters["token"] = NSUserDefaults.standardUserDefaults().token
    parameters["id_user"] = NSUserDefaults.standardUserDefaults().id
    request(.PUT, "http://emannonces.ovh/emannoncesAPI/index.php/api/\(item.api)/\(item.idItem)", parameters: parameters)
      .responseJSON { jsonResponse in
        if let json = jsonResponse.result.value, let decoded: Decoded<SuccessResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: jsonResponse.result.error)
        }
    }
  }
}