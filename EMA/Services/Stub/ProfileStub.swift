//
//  ProfileStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 01/06/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct ProfileStub: ProfileAPI {
  
  func requestAllCreatedItems(userId: Int, completionBlock: (response: ProfileResponse?, error: NSError?) -> ()) {
    let lostObjects = [
      LostObject(id: 1, title: "Veste noir perdu", description: "J’ai perdu ma veste noire en cuir hier au bar. Si quelqu’un a trouvé, merci de me contacter au 07 83 91 74 70.", location:"Hopital Alès", found: false, creatorFirstName: "Yasmin", creatorLastName: "Cesar", creatorPhoneNumber: nil, creatorLogin: "aymen.rebouh", createdDate: "2016-06-10 10:37:12"),
      
      LostObject(id: 2, title: "Perdu boucle d’oreille au bar", description: "Salut, je tente ma chance au cas ou ! J’ai perdu une boucle d’oreille ( un espèce de petit anneau couleur argent ) en soirée hier soir, si quelqu’un l’a trouvé, ça serait le top !", location:"Bar Alès", found: false, creatorFirstName: "Fanny", creatorLastName: "Croset", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-05-10 10:37:12"),
      
      LostObject(id: 3, title: "Perdu portefeuille", description: "Bonjour à tous, j’ai perdu mon portefeuille probablement hier soir à 19h vers le portail d’etrée de la Meuh. Y’a toute ma vie à l’intérieur. Si par hasard quelqu’un l’aurait trouvé, merci de me contacter au  06 35 33 42 14.", location: "", found: false, creatorFirstName: "Benjamin", creatorLastName: "Mariot", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-04-10 10:37:12" ),
      
      LostObject(id: 4, title: "Téléphone perdu portable", description: "Bonjour à tous! J’ai perdu mon portble ce matin à la meuh devant batiment G, c’est un Mi4i noir. Chais pas s’il y a quelqu’un qui l’a récupéré ? Merci de le retourner a G06 SVP ou bien de le déposer à l’administration. Merci à vous!", location: "Marseille", found: true, creatorFirstName: "Shang", creatorLastName: "Zhou Xia", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-03-10 10:37:12")
    ]
    
    let events = [
      Event(id: 1, title: "Soirée Medecine ce soir", description: "Bonjour à tous, ceci est un message des internes de l’hôpital d’Alès ! Vendredi soir, nous organisons une fiesta dans notre internet. Si vous êtes chaud(e)s, vous êtes les bienvenu(e)s...", type: .Party, location: "Hôpital d’Alès", startDate: "2016-03-10 10:37:12", endDate: "2016-03-12 10:37:12", createdDate: "2016-03-10 10:37:12", creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login),
      
      Event(id: 2, title: "Soirée brésilienne", description: "Bière 1€, Shot de CACHAÇA 1€, Surprise gratuite ! Totale immersion au pays du SAMBA, du FUNK, du CARNAVAL, du SOLEIL et du FOOTBALL!! On vous attends demain 19h pour boire et danser avec nous!! Bisous!!!!!!!", type: .Party,  location: "Bar d'Alès", startDate: "2016-03-13 10:37:12", endDate: "2016-03-14 10:37:12",  createdDate: "2016-03-10 10:37:12", creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login)]
    
    let advertisements = [
      Advertisment(id: 1, title: "Places cinéma Kinepolis ou Forum", description: "Bonsoir. Tout est dans le titre ou presque. J'ai trois places à vendre (valables jusqu'au 28 avril, donc ce jeudi).", type: AdvertismentType.Sale, price: 6, createdDate: "2016-06-10 10:37:12", creatorFirstName: "Julien", creatorLastName: "Baque", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
      Advertisment(id: 2, title: "Maison à louer / Nîmes", description: "Bonjour à tous, Un intervenant doit s’absenter quelques mois et souhaiterait mettre sa maison en location du 01 mars au 31 juillet 2016. Si cela vous intéresse, merci de me contacter par retour de mail, je ferai suivre", type: AdvertismentType.Renting, price: 0, createdDate: "2016-06-08 10:37:12", creatorFirstName: "Catherine", creatorLastName: "Lecompere", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh")]
    
    let carsPooling = [
      CarPooling(id: 1, startArrival: "Marseille", endArrival: "Paris", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 38, seatAvailable: 4, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh"),
      
      CarPooling(id: 2, startArrival: "Paris", endArrival: "Lille", startDate: "2016-04-22 18:00:00", createdDate: "2016-04-22 18:00:00", description: "dddd", price: 10.5, seatAvailable: 2, creatorFirstName: "Aymen", creatorLastName: "Rebouh", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh")]

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(response: ProfileResponse(lostObjects: lostObjects, events: events, advertisments: advertisements, carsPooling: carsPooling), error: nil)
      }
    }
  }
  
  func requestDelete(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(SuccessResponse(success: true), error: nil)
      }
    }
  }

  func requestUpdate(item: CrudItem, completionBlock: SuccessResponseCompletionBlock) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(SuccessResponse(success: true), error: nil)
      }
    }
  }
}
