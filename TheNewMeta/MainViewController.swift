//
//  MainViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // TODO: Does this need to be a constant?
    var currentGames = [String]()
    
    @IBOutlet weak var tableViewContent: UITableView!
    
    @IBAction func clickHamburger() {
        //        print("TOGGLE SIDE MENU")
        // On click this will send a message to the side menu to run the constraint function!! This is a View Click action to the ContainerViewController
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    func getData() {
        let realm = try! Realm()
        let returnedGames = realm.objects(Game.self)
        print("This is all the games in the DB \(returnedGames.count)")
        for game in returnedGames {
            currentGames.append(game.title)
        }
    }
    
    // Lobbies Table
    
    // How many sections in your table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // How many rows in your table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGames.count
    }
    
    // What are the contents of each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "gameTitleCell")
        //        print("This is the textLabel:")
        // The indexPath moves down the array and prints each string in their own row
        cell.textLabel?.text = currentGames[indexPath.row]
        // Return the cell view
        return cell
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
    
    // Notification Center Functions
    
    // Will be consumed by the NC --> Messages are sent from the sideMenuViewController on click
    @objc func showCreateLobby () {
        performSegue(withIdentifier: "ShowCreateLobby", sender: nil)
    }
    
    @objc func showMyLobbies () {
        performSegue(withIdentifier: "ShowMyLobbies", sender: nil)
    }
    
    @objc func showEditProfile () {
        performSegue(withIdentifier: "ShowEditProfile", sender: nil)
    }
    
    //    @objc func showLoginView () {
    //        performSegue(withIdentifier: "ShowLoginView", sender: nil)
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        
        // Navigation Bar Observers - Waiting for an on-click message
        
        // On load, add the observers to the NC to be listening for a click event!!!
        NotificationCenter.default.addObserver(self, selector: #selector(showCreateLobby), name: NSNotification.Name("ShowCreateLobby"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMyLobbies), name: NSNotification.Name("ShowMyLobbies"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEditProfile), name: NSNotification.Name("ShowEditProfile"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(showLoginView), name: NSNotification.Name("ShowLoginView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentGames = [String]()
        print("This is the viewDidAppear")
        getData()
        self.tableViewContent.reloadData()
    }
}
