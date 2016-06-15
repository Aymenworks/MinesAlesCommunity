//
//  EventAPI.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol EventAPI {
  func requestAllEvents(completionBlock: (EventResponse?, NSError?) -> ())
  func requestAddEvent(title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType, creatorId: Int, completionBlock:  AddResponseCompletionBlock)
}