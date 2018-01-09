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
    // List of all lobbies that this user has joined
    var userJoinedLobbies = List<Lobby>()
    
    // List of all lobbies that the user has created
    var userCreatedLobbies = List<Lobby>()
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
    // @objc dynamic var game: Game?
    @objc dynamic var numberOfPlayers: Int = 0
    @objc dynamic var message: String = ""
    
    // All users that have joined this lobby
    var lobbyUsers = List<User>()
    
    override static func primaryKey() -> String? {
        return "lobbyID"
    }
}

//    Lobby {
//    lobbyID = 4A362BCD-97C8-4D02-BE37-E314869DF7D1;
//    hostID = 421F7DC6-EF38-4A7E-BB0E-8CEB1D6347AD;
//    game = Game {
//    gameID = 1AFB77B7-1DEB-4278-BF93-042DAAE992F1;
//    title = NotOverWatch;
//    };
//    numberOfPlayers = 1;
//    message = Looking for you!;
//    }
//

// Might want to make another attributes of Game where game has a list of all lobbies !
class Game: Object {
    @objc dynamic var gameID: String = UUID().uuidString
    @objc dynamic var title: String = ""
    // For every lobby that is created under that game name, add that lobby to this list in game object
    var matchingLobbies = List<Lobby>()
    
    override static func primaryKey() -> String? {
        return "gameID"
    }
}
