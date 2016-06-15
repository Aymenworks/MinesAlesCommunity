//
//  EventStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 30/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct EventStub: EventAPI {
  func requestAllEvents(completionBlock: (EventResponse?, NSError?) -> ()) {
    let events = [
      Event(id: 1, title: "Soirée Medecine ce soir", description: "Bonjour à tous, ceci est un message des internes de l’hôpital d’Alès ! Vendredi soir, nous organisons une fiesta dans notre internet. Si vous êtes chaud(e)s, vous êtes les bienvenu(e)s...", type: .Party, location: "Hôpital d’Alès", startDate: "2016-03-10 10:37:12", endDate: "2016-03-12 10:37:12", createdDate: "2016-03-10 10:37:12", creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login),
      
      Event(id: 2, title: "Soirée brésilienne", description: "Bière 1€, Shot de CACHAÇA 1€, Surprise gratuite ! Totale immersion au pays du SAMBA, du FUNK, du CARNAVAL, du SOLEIL et du FOOTBALL!! On vous attends demain 19h pour boire et danser avec nous!! Bisous!!!!!!!", type: .Party,  location: "Bar d'Alès", startDate: "2016-03-13 10:37:12", endDate: "2016-03-14 10:37:12",  createdDate: "2016-03-10 10:37:12", creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login),
      
      Event(id: 3, title: "Sortie TRAIL", description: "Pour vous remettre de vos émotions du Gala, on vous propose de venir vous dégourdir les jambes et d'éliminer tous les excès en tout genres que vous avez pu prendre :) Départ de la Meuh pour environ 30 à 40min de Trail (on aura du chemin et de la route) et environ 5 km que tu sois débutant ou confirmé ça sera chacun à son rythme !! Rendez-vous au BAT N à 18h45 avec obligatoirement une lampe frontale. Sportivement, Vos capitaines TRAIL", type: .Outings, location: "Batiment N", startDate: "2016-04-05 10:37:12", endDate: "2016-04-06 10:37:12",  createdDate: "2016-03-10 10:37:12", creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login),
      
      Event(id: 4, title: "Escalade sortie falaise", description: "Jeudi nous irons en falaise il y fait chaud on est sous le soleil ! Départ de la meuh à 13 :15 nous serons de retour avant 17 :00 Cours débutants comme confirmés,  vous n'avez pas besoin d’avoir de matériel. Le club fournit le matériel nécessaire.",  type: .Sport, location: "Hôpital d’Alès", startDate: "2016-05-05 10:37:12" , endDate: "2016-05-06 10:37:12",  createdDate: "2016-03-10 10:37:12",  creatorFirstName: NSUserDefaults.standardUserDefaults().firstName, creatorLastName: NSUserDefaults.standardUserDefaults().lastName, creatorPhoneNumber: NSUserDefaults.standardUserDefaults().phoneNumber, creatorLogin: NSUserDefaults.standardUserDefaults().login)
    ]
    let response = EventResponse(events: events)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(response, nil)
      }
    }
  }
  
  func requestAddEvent(title: String, location: String, startDate: String, endDate: String, createdDate: String, description: String, type: EventType, creatorId: Int, completionBlock:  AddResponseCompletionBlock) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(AddResponse(id: 5+(Int(arc4random()))%2000), error: nil)
      }
    }
  }
}