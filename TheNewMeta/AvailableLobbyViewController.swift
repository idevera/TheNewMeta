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
    
    private var signedInUser = User()

    let lobbyCellIdentifier = "LobbyTableCell"
    
    
    @IBOutlet weak var lobbyTableView: UITableView!
    
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
        // If your storyboard is set up correctly, and the cellIdentifier matches the identifier from your storyboard, then the downcast should never fail. If the downcast does fail, the fatalError() function prints an error message to the console and terminates the app
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyCellIdentifier, for: indexPath) as? LobbyViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        // The table view will iterate over each thing in the matchingLobbies
        let lobby = chosenGame?.matchingLobbies[indexPath.row]
        
        // Find the matching User of the lobby and return back their name
        let lobbyHost = findLobbyCreatorName(hostID: (lobby?.hostID)!)
        
        cell.gamerTagLabel.text = lobbyHost.gamerTag
        cell.numPlayersLabel.text = "\(lobby?.numberOfPlayers ?? 0)"
        cell.messageLabel.text = lobby?.message
        
        // Save the index of the matchingLobbies array that currently are in
        cell.joinButton.tag = indexPath.row
        
        // Attach a click action
        cell.joinButton.addTarget(self, action: #selector(AvailableLobbyViewController.checkIfJoined), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    @objc private func checkIfJoined(sender: UIButton)  {
        let currentLobby = chosenGame?.matchingLobbies[sender.tag]
        let matchingUser = currentLobby?.lobbyUsers.filter("userID == '\(signedInUser.userID)'").first
        if matchingUser == nil {
            joinLobby(currentLobby: currentLobby!)
        } else {
            // TODO: PLEASE RAISE ARGUMENT ERROR HERE
            print("YOU HAVE ALREADY JOINED THIS LOBBY")
        }
    }
    
    // The joinButton when clicked will send a message for this function to run
    private func joinLobby(currentLobby: Lobby) {
        let realm = try! Realm()
        
        try! realm.write {
            currentLobby.lobbyUsers.append(signedInUser)
        }
        
        print("This is my current Lobby users: \(String(describing: currentLobby.lobbyUsers))")
    }
    
    private func findSignedInUser() {
        // TODO: Should probably save the entire user object in the UserDefaults instead of just the ID
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        print("This is the id of the signed in user \(String(describing: id))")
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        
        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
    private func findLobbyCreatorName(hostID: String) -> User {
        let realm = try! Realm()
        let userCreator = realm.objects(User.self).filter("userID = '\(hostID)'").first
        print("This is the userCreator: \(String(describing: userCreator))")
        return userCreator!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lobbyTableView.delegate = self
        lobbyTableView.dataSource = self
        
        // Find the user and save it as a variable in this view
        findSignedInUser()
        
        print("This is the avilableLobbyVC chosen game: \(String(describing: chosenGame))")
    }
}
