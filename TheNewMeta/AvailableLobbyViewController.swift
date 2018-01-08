//
//  AvailableLobbyViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/7/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class AvailableLobbyViewController: UIViewController {

    var chosenGame: Game?
    // This should be an array of all lobbies
    var gameLobbies = [Lobby]()
    
    private func getMatchingLobbies() {
//        let realm = try! Realm()
        
        // In product, look for any property of productTypelist.typeName that is equal to %@ --> productTypeName = "electronics"
//        realm.objects(Product.self).filter("ANY productTypeList.typeName == %@", productTypeName)
//        let returnedLobbies = realm.objects(Lobby.self).filter("ANY game = chosenGame")
//        print("This is all the games in the DB \(returnedLobbies.count)")
//        for lobby in returnedLobbies {
//            gameLobbies.append(lobby)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getMatchingLobbies()
        print("This is the avilableLobbyVC chosen game: \(String(describing: chosenGame))")
        print("This is the gameLobbies that match this game: \(gameLobbies)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
