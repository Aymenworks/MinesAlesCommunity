//
//  AbstractService.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol LostObjectAPI {
  func requestAllLostObjects(completionBlock: (LostObjectResponse?, NSError?) -> ())
  func requestAddLostObject(title: String, description: String, found: Bool, creatorId: Int, location: String, createdDate: String,
                            completionBlock: AddResponseCompletionBlock)
}