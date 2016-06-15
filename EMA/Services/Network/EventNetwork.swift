//
//  EventNetwork.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Curry

struct EventNetwork: EventAPI {
  func requestAllEvents(completionBlock: (EventResponse?, NSError?) -> ()) {
    request(.GET, "http://emannonces.ovh/emannoncesAPI/index.php/api/event")
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<EventResponse> = decode(json), let response = decoded.value {
          completionBlock(response, nil)
        } else {
          completionBlock(nil, response.result.error)
        }
    }
  }
  
  func requestAddEvent(title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType, creatorId: Int, completionBlock: AddResponseCompletionBlock) {
    request(.POST, "http://emannonces.ovh/emannoncesAPI/index.php/api/event", parameters: ["title": title, "location": location, "start_date": startDate, "end_date": endDate, "created_date": createdDate, "description": description, "event_type": type.rawValue, "id_user": creatorId, "token": NSUserDefaults.standardUserDefaults().token])
      .responseJSON { response in
        if let json = response.result.value, let decoded: Decoded<AddResponse> = decode(json), let response = decoded.value {
          completionBlock(response, error: nil)
        } else {
          completionBlock(nil, error: response.result.error)
        }
    }
  }
}