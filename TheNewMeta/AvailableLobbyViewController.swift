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
        // If your storyboard is set up correctly, and the cellIdentifier matches the identifier from your storyboard, then the downcast should never fail. If the downcast does fail, the fatalError() function prints an error message to the console and terminates the app
        guard let cell = tableView.dequeueReusableCell(withIdentifier: lobbyCellIdentifier, for: indexPath) as? LobbyViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        // The table view will iterate over each thing in the matchingLobbies
        let lobby = chosenGame?.matchingLobbies[indexPath.row]

        cell.gamerTagLabel.text = lobby?.hostID
        cell.numPlayersLabel.text = "\(lobby?.numberOfPlayers ?? 0)"
        cell.messageLabel.text = lobby?.message
        cell.joinButton.addTarget(self, action: #selector(AvailableLobbyViewController.print123), for: UIControlEvents.touchUpInside)
        // cell.joinButton.addTarget(self, action: #selector(ClassName.FunctionName.buttonTapped), for: .touchUpInside)
        
        // cell.joinButton addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // Return the cell view
        return cell
    }
    
    // TODO: How to pass the lobby object into this function
    @objc func print123() {
        print("Greeting worked!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LobbyTableView.delegate = self
        LobbyTableView.dataSource = self
        
        print("This is the avilableLobbyVC chosen game: \(String(describing: chosenGame))")
    }
}
