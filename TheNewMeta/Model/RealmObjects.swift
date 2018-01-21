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
    @objc dynamic var apiGameID: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var imageURL: String = ""
    
    // For every lobby that is created under that game name, add that lobby to this list in game object
    var matchingLobbies = List<Lobby>()
    
    override static func primaryKey() -> String? {
        return "gameID"
    }
}

//class StarWarsSpecies {
//    var idNumber: Int?
//    var name: String?
//    var classification: String?
//    var designation: String?
//    var averageHeight: Int?
//    var skinColors: [String]?
//    var hairColors: [String]?
//    var eyeColors: [String]?
//    var averageLifespan: String?
//    var homeworld: String?
//    var language: String?
//    var people: [String]?
//    var films: [String]?
//    var created: Date?
//    var edited: Date?
//    var url: String?
//
//    required init(json: [String: Any]) {
//        self.name = json[SpeciesFields.Name.rawValue] as? String
//        self.classification = json[SpeciesFields.Classification.rawValue] as? String
//        self.designation = json[SpeciesFields.Designation.rawValue] as? String
//        self.averageHeight = json[SpeciesFields.AverageHeight.rawValue] as? Int
//        // TODO: more fields!
//    }
//}

