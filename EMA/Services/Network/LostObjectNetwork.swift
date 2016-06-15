//
//  LostObjectNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Curry

struct LostObjectNetwork: LostObjectAPI {
  func requestAllLostObjects(completionBlock: (LostObjectResponse?, NSError?) -> ()) {
    request(.GET, "http://emannonces.ovh/emannoncesAPI/index.php/api/lostItem")
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<LostObjectResponse> = decode(json), let response = decoded.value {
          completionBlock(response, nil)
        } else {
         completionBlock(nil, response.result.error)
        }
    }
  }
  
  func requestAddLostObject(title: String, description: String, found: Bool, creatorId: Int, location: String, createdDate: String, completionBlock: AddResponseCompletionBlock) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/lostItem", parameters: ["title": title, "description": description, "found": found, "id_user": creatorId, "created_date": createdDate, "location": location, "token": NSUserDefaults.standardUserDefaults().token])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<AddResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: nil)
        }
    }
  }
}
