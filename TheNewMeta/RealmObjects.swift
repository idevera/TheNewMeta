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
    @objc dynamic var userID: String = UUID().uuidString
    @objc dynamic var gamerTag: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

//@objc dynamic var name: String = ""
//@objc dynamic var adopted: Bool = false
//let siblings = List<Dog>()
//}

class Lobby: Object {
    @objc dynamic var lobbyID: String = UUID().uuidString
    @objc dynamic var hostID: String = ""
    // Objects must be optional
    @objc dynamic var game: Game?
    @objc dynamic var numberOfPlayers: Int = 0
    @objc dynamic var message: String = ""
    
    override static func primaryKey() -> String? {
        return "lobbyID"
    }
}

class Game: Object {
    @objc dynamic var gameID: String = UUID().uuidString
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "gameID"
    }
}
