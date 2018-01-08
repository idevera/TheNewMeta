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

class AvailableLobbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var chosenGame: Game?
    
    let lobbyCellIdentifier = "LobbyTableCell"
    
    @IBOutlet weak var LobbyTableView: UITableView!
    
    // Lobby Tables
    
    // How many sections in your table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // How many rows in your table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenGame!.matchingLobbies.count
    }
    
    // What are the contents of each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The as? MealTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your MealTableViewCell class. This returns an optional.
        // The guard let expression safely unwraps the optional.
        // If your storyboard is set up correctly, and the cellIdentifier matches the identifier from your storyboard, then the downcast should never fail. If the downcast does fail, the fatalError() function prints an error message to the console and terminates the app.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyCellIdentifier, for: indexPath) as? LobbyViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        // The table view will iterate over each thing in the matchingLobbies
        let lobby = chosenGame?.matchingLobbies[indexPath.row]
        
        
//        The text of your textField is an optional value because a text field can sometimes be empty. So, use an if let to unwrap the variable and make sure it's not nil — otherwise your program could crash:
        cell.gamerTagLabel.text = lobby?.hostID
        
//        print("Value is \(optionalValue as Int?)")
        let players = "\(lobby?.numberOfPlayers ?? 0)"
        cell.numPlayersLabel.text = players
        cell.messageLabel.text = lobby?.message
        
//        var myVariable = 1
//
//        myVariable += 1
//        label.text = string(myVariable)
        
//        let x : Int = 42
//        var myString = String(x)

        //        @IBOutlet weak var gamerTagLabel: UILabel!
//        @IBOutlet weak var numPlayersLabel: UILabel!
//        @IBOutlet weak var messageLabel: UILabel!
        
//        @objc dynamic var lobbyID: String = UUID().uuidString
//        @objc dynamic var hostID: String = ""
//        // Objects must be optional
//        //    @objc dynamic var game: Game?
//        @objc dynamic var numberOfPlayers: Int = 0
//        @objc dynamic var message: String = ""
//
//        override static func primaryKey() -> String? {
//            return "lobbyID"
//        }
        
        // Return the cell view
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LobbyTableView.delegate = self
        LobbyTableView.dataSource = self
        print("This is the avilableLobbyVC chosen game: \(String(describing: chosenGame))")
//        print("This is the gameLobbies that match this game: \(chosenGame?.matchingLobbies)")

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
