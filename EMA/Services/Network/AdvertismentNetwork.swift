
//
//  AdvertismentNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 11/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Curry

struct AdvertismentNetwork: AdvertismentAPI {
  func requestAllAdvertisments(completionBlock: (AdvertismentResponse?, NSError?) -> ()) {
    request(.GET, "http://emannonces.ovh/emannoncesAPI/index.php/api/advertisement")
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<AdvertismentResponse> = decode(json), let response = decoded.value {
          completionBlock(response, nil)
        } else {
          completionBlock(nil, response.result.error)
        }
    }
  }
  
  func requestAddAdvertisment(title title: String, description: String, price: Float, createdDate: String, type: AdvertismentType, creatorId: Int, completionBlock:AddResponseCompletionBlock) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/advertisement", parameters: ["title": title, "description": description,
      "adv_type": type.rawValue, "created_date": createdDate, "id_user": creatorId])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<AddResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: response.result.error)
        }
    }

  }
}