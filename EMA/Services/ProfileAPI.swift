//
//  ProfileAPI.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol ProfileAPI {
  func requestAllCreatedItems(userId: Int, completionBlock: (response: ProfileResponse?, error: NSError?) -> ())
  func requestUpdate(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) 
  func requestDelete(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) 
}
