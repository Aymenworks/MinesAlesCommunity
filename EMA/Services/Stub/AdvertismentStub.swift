//
//  AdvertisementStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 09/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct AdvertismentStub: AdvertismentAPI {
  func requestAllAdvertisments(completionBlock: (AdvertismentResponse?, NSError?) -> ()) {
    let advertisements =
    [
      Advertisment(id: 1, title: "Places cinéma Kinepolis ou Forum", description: "Bonsoir. Tout est dans le titre ou presque. J'ai trois places à vendre (valables jusqu'au 28 avril, donc ce jeudi).", type: AdvertismentType.Sale, price: 6, createdDate: "2016-06-10 10:37:12", creatorFirstName: "Julien", creatorLastName: "Baque", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
      Advertisment(id: 2, title: "Maison à louer / Nîmes", description: "Bonjour à tous, Un intervenant doit s’absenter quelques mois et souhaiterait mettre sa maison en location du 01 mars au 31 juillet 2016. Si cela vous intéresse, merci de me contacter par retour de mail, je ferai suivre", type: AdvertismentType.Renting, price: 0, createdDate: "2016-06-08 10:37:12", creatorFirstName: "Catherine", creatorLastName: "Lecompere", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
      Advertisment(id: 3, title: "Disque dur prêté", description: "Salut à tous, Pablo a prêté mon Disque Dur à l'un de vous et ne se souvient plus qui... Si la personne concernée pouvait me contacter ça serait sympa (c'est un Western Digital adaptable pour Mac) avec une petite pochette noire avec fermeture éclaire. J'en ai vraiment besoin et ce n'est pas donné...", type: AdvertismentType.Various, price: 0, createdDate: "2016-02-10 10:37:12", creatorFirstName: "Nicolas", creatorLastName: "Piccot", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh")
    ]
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(AdvertismentResponse(advertisements: advertisements), nil)
      }
    }
  }
  
  func requestAddAdvertisment(title title: String, description: String, price: Float, createdDate: String, type: AdvertismentType, creatorId: Int, completionBlock:AddResponseCompletionBlock) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
        dispatch_async(dispatch_get_main_queue()) {
          completionBlock(AddResponse(id: 5+(Int(arc4random()))%2000), error: nil)
        }
    }
  }
}