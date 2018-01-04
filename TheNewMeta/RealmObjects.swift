//
//  RealmObjects.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var userID = UUID().uuidString
    @objc dynamic var gamerTag = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Lobby: Object {
    @objc dynamic var hostID = ""
    @objc dynamic var game = ""
    @objc dynamic var numberOfPlayers = 0
    @objc dynamic var message = ""
}

