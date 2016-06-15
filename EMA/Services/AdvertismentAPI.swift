//
//  AdvertisementAPI.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

protocol AdvertismentAPI {
  func requestAllAdvertisments(completionBlock: (AdvertismentResponse?, NSError?) -> ())
  func requestAddAdvertisment(title title: String, description: String, price: Float, createdDate: String, type: AdvertismentType, creatorId: Int, completionBlock:  AddResponseCompletionBlock)
}