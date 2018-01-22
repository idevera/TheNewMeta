//
//  AppDelegate.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let gameApiIds = ["3030-48190", "3030-48320"]
    var apiKey = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure the Realm Database first
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 18,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 19) {
                    var nextID = UUID().uuidString
                    migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
                        newObject!["userID"] = nextID
                        nextID = UUID().uuidString
                    }
                    migration.enumerateObjects(ofType: Lobby.className()) { oldObject, newObject in
                        newObject!["lobbyID"] = nextID
                        nextID = UUID().uuidString
                    }
                    migration.enumerateObjects(ofType: Game.className()) { oldObject, newObject in
                        newObject!["gameID"] = nextID
                        nextID = UUID().uuidString
                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        config.deleteRealmIfMigrationNeeded = true
        
        // Get the api key
        apiKey = valueForAPIKey(named: "GIANT_BOMB_API_KEY")
        getCurrentGames()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func valueForAPIKey(named keyname:String) -> String {
        var resourceFileDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
        }
        if let resourceFileDictionaryContent = resourceFileDictionary {
            let value = resourceFileDictionaryContent[keyname] as! String
            return value
        }
        print("Game does not exist")
        return ""
    }
    
    private func getCurrentGames() {
        let realm = try! Realm()
        
        let returnedGame = realm.objects(Game.self)
        var i = 0
        var currentGamesIDs = [String]()
        
        while i < returnedGame.count {
            currentGamesIDs.append(returnedGame[i].apiGameID)
            i += 1
        }
        
        while i < gameApiIds.count {
            if currentGamesIDs.contains(gameApiIds[i]) {
                getGameJsonData()
            } else {
                print("These games have already been created!")
            }
        }
    }
    
    private func getGameJsonData() {
        var i = 0
        while i < gameApiIds.count {
            let id = gameApiIds[i]
            
            let url = URL(string: "http://www.giantbomb.com/api/game/"+id+"/?api_key="+apiKey+"&format=json&field_list=name,image")
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data, let response = response as? HTTPURLResponse {
                    do {
                        // Convert the data to JSON
                        let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        if let json = jsonSerialized,
                            let results = json["results"] as? [String: Any],
                            let name = results["name"],
                            let imageDict = results["image"] as? [String: String],
                            let gameImageUrl = imageDict["icon_url"]
                        {
                            self.createGameObject(gameName: name as! String, imageURL: gameImageUrl, gameID: id)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            task.resume()
            i += 1
            
        }
    }
    
    private func createGameObject(gameName: String, imageURL: String, gameID: String) {
        let game = Game()
        game.title = gameName
        game.imageURL = imageURL
        game.apiGameID = gameID
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(game)
        }
    }


}

