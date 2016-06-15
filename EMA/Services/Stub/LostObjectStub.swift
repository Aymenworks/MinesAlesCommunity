//
//  LostObjectStub.swift
//  EMA
//
//  Created by Rebouh Aymen on 24/05/2016.
//  Copyright © 2016 Aymen Rebouh. All rights reserved.
//

import Foundation

struct LostObjectStub: LostObjectAPI {
  func requestAllLostObjects(completionBlock: (LostObjectResponse?, NSError?) -> ()) {
    let lostObjects = [
      LostObject(id: 1, title: "Veste noir perdu", description: "J’ai perdu ma veste noire en cuir hier au bar. Si quelqu’un a trouvé, merci de me contacter au 07 83 91 74 70.", location:"Hopital Alès", found: false, creatorFirstName: "Yasmin", creatorLastName: "Cesar", creatorPhoneNumber: nil, creatorLogin: "aymen.rebouh", createdDate: "2016-06-10 10:37:12"),
    
      LostObject(id: 2, title: "Perdu boucle d’oreille au bar", description: "Salut, je tente ma chance au cas ou ! J’ai perdu une boucle d’oreille ( un espèce de petit anneau couleur argent ) en soirée hier soir, si quelqu’un l’a trouvé, ça serait le top !", location:"Bar Alès", found: false, creatorFirstName: "Fanny", creatorLastName: "Croset", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-05-10 10:37:12"),
      
      LostObject(id: 3, title: "Perdu portefeuille", description: "Bonjour à tous, j’ai perdu mon portefeuille probablement hier soir à 19h vers le portail d’etrée de la Meuh. Y’a toute ma vie à l’intérieur. Si par hasard quelqu’un l’aurait trouvé, merci de me contacter au  06 35 33 42 14.", location: "", found: false, creatorFirstName: "Benjamin", creatorLastName: "Mariot", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-04-10 10:37:12" ),
      
      LostObject(id: 4, title: "Téléphone perdu portable", description: "Bonjour à tous! J’ai perdu mon portble ce matin à la meuh devant batiment G, c’est un Mi4i noir. Chais pas s’il y a quelqu’un qui l’a récupéré ? Merci de le retourner a G06 SVP ou bien de le déposer à l’administration. Merci à vous!", location: "Marseille", found: true, creatorFirstName: "Shang", creatorLastName: "Zhou Xia", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-03-10 10:37:12"),
      
      LostObject(id: 5, title: "Perdu clef C19", description: "Salut les gens, j’ai perdu les clefs de la chambre C19 ( le numéro de la chambre est inscrit sur le porte clef ). Si vous les retrouvez, merci de me contacter au 06 80 15 53 50.", location:"Bar Alès", found: false, creatorFirstName: "Omart", creatorLastName: "Sakout", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-06-02 10:37:12"),
      
      LostObject(id: 6, title: "Clé de voiture Citroën", description: "Bonjour,Il a été trouvé une clé de voiture Citroën ce matin au bâtiment B Clavières (à proximité du photocopieur). Cette clé est à disposition au bureau B101.", location:"Bar Alès", found: true, creatorFirstName: "Christophe", creatorLastName: "Vieljus", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: NSDateFormatter.dateFormatter.stringFromDate(NSDate())),
      
      LostObject(id: 7, title: "Classeur de droit", description: "On a trouvé un petit classeur avec des fiches de révision appartenant à une certaine Pauline GOMBERT. Je PENSE que c'est du droit, ces écritures me paraissent bien obscures. La Bise.", location:"Bar Alès", found: true, creatorFirstName: "Nicolas", creatorLastName: "Simon", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-02-10 10:37:12"),
      
      LostObject(id: 8, title: "Bracelet", description: "Il a été trouvé un bracelet sur le site de Clavières - Alès. Ce bracelet est à disposition au bureau des correspondants des études B101.", location:"Bar Alès", found: true, creatorFirstName: "Christophe", creatorLastName: "Vieljus", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-01-10 10:37:12"),
      
      LostObject(id: 9, title: "Cassette", description: "Bonjour, Il a été trouvé ce matin sur le muret devant l’entrée du Bât A, une cassette KODAK vidéo E-120 « Ingénieur en 4 ans EMA « 1995 », Elle est à votre disposition à l’accueil de l’Ecole – « 6, avenue de Clavières »., Cordialement.", location:"Bar Alès", found: true, creatorFirstName: "Pascale", creatorLastName: "Altier", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-03-15 10:37:12"),
      
      LostObject(id: 10, title: "Veste", description: "Bonjour,Une veste a été trouvée en amphi Baujon. Son propriétaire peut la récupérer dans mon bureau. Merci.", location:"Bar Alès", found: true, creatorFirstName: "Veronique", creatorLastName: "Galon", creatorPhoneNumber: "0623185407", creatorLogin: "aymen.rebouh", createdDate: "2016-03-19 10:37:12")
    ]
    
    let response = LostObjectResponse(lostObjects: lostObjects)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(response, nil)
      }
    }
  }
  
  func requestAddLostObject(title: String, description: String, found: Bool, creatorId: Int, location: String, createdDate: String, completionBlock: AddResponseCompletionBlock) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0)) {
      dispatch_async(dispatch_get_main_queue()) {
        completionBlock(AddResponse(id: 11+(Int(arc4random())%2000)), error: nil)
        }
    }
  }
}