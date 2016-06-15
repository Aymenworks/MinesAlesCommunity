//
//  Event.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

import Foundation
import Argo
import Curry

enum EventType: String, Decodable {
  case Party = "Soiree", Outings = "Sortie", Sport = "Sport", Various = "Divers"
}

struct Event {
  let id: Int
  var title: String
  var description: String
  var type: EventType
  var location: String?
  var startDate: String
  var endDate: String
  var createdDate: String

  let creatorFirstName: String?
  let creatorLastName: String?
  let creatorPhoneNumber: String?
  let creatorLogin: String?
  
  var creatorName: String {
    return "\(creatorFirstName) \(creatorLastName)"
  }
}

// MARK: - Network Mapping -

extension Event: Decodable {
  static func decode(json: JSON) -> Decoded<Event> {
    let decoded = curry(Event.init)
      <^> (json <| "id" >>- toInt)
      <*> json <| "title"
      <*> json <| "description"
      <*> json <| "event_type"
      <*> json <|? "location"

    return decoded
      <*> json <| "start_date"
      <*> json <| "end_date"
      <*> json <| "created_date"
      <*> json <|? "firstname"
      <*> json <|? "lastname"
      <*> json <|? "phone"
      <*> json <|? "login"
  }
}

// MARK: - CrudItem Protocol -

extension Event: CrudItem {
  var api: String {
    return "event"
  }
  
  var idItem: Int {
    return id
  }
  
  var updateParameters: [String : AnyObject]  {
    return ["title": title, "location": location ?? "", "start_date": startDate, "end_date": endDate, "description": description, "event_type": type.rawValue]
  }
}