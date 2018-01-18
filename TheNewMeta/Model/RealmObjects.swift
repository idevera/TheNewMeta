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
    // List of all lobbies that the user has created
    var createdLobbies = List<Lobby>()
    
    // List of all lobbies that this user has joined
    let joinedLobbies = LinkingObjects(fromType: Lobby.self, property: "lobbyUsers")

    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Lobby: Object {
    @objc dynamic var lobbyID: String = UUID().uuidString
    @objc dynamic var hostID: String = ""
    
    // Objects must be optional
    // @objc dynamic var game: Game?
    private let games = LinkingObjects(fromType: Game.self, property: "matchingLobbies")
    var game: Game {
        return self.games.first!
    }
    @objc dynamic var numberOfPlayers: Int = 0
    @objc dynamic var message: String = ""
    
    // All users that have joined this lobby
    var lobbyUsers = List<User>()
    
    override static func primaryKey() -> String? {
        return "lobbyID"
    }
}

// Might want to make another attribute of Game where game has a list of all lobbies !
class Game: Object {
    @objc dynamic var gameID: String = UUID().uuidString
    @objc dynamic var title: String = ""
    
    // For every lobby that is created under that game name, add that lobby to this list in game object
    var matchingLobbies = List<Lobby>()
    
    override static func primaryKey() -> String? {
        return "gameID"
    }
}
