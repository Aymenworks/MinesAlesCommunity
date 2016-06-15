//
//  CarPoolingNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 14/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Curry

struct CarPoolingNetwork: CarPoolingAPI {
  
  func requestAllCarsPooling(completionBlock: (CarPoolingResponse?, NSError?) -> ()) {
      request(.GET, "http://emannonces.ovh/emannoncesAPI/index.php/api/carpool")
        .responseJSON { response in
          if let json = response.result.value, let decoded: Decoded<CarPoolingResponse> = decode(json), let response = decoded.value {
            completionBlock(response, nil)
          } else {
            completionBlock(nil, response.result.error)
          }
    }
  }
  
  func requestAddCarPooling(startLocation: String, endLocation: String, startDate: String, createdDate: String, price: Float, numberOfSeats: Int, description: String, creatorId: Int, completionBlock: AddResponseCompletionBlock) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/carpool", parameters:  ["start": startLocation, "arrival": endLocation, "start_date": startDate, "created_date": createdDate, "description": description, "price": price, "seat_available": numberOfSeats, "id_user": NSUserDefaults.standardUserDefaults().id, "token": NSUserDefaults.standardUserDefaults().token])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<AddResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: nil)
        }
    }

  }
}
