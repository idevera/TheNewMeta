//
//  MainViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // Properties
    
    // TODO: Does this need to be a constant?
    var currentGames = [Game]()
    var filteredData = [Game]()
    private var signedInUser = User()
    let gameCellIdentifier = "gameTitleCell"
    
    @IBOutlet weak var tableViewContent: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBAction func logoutButton(_ sender: Any) {
        showLoginView()
    }
    // Table View for all games

    // How many sections in your table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // How many rows in your table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // What are the contents of each cell?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The as? MealTableViewCell expression attempts to downcast the returned object from the UITableViewCell class to your MealTableViewCell class. This returns an optional.
        // The guard let expression safely unwraps the optional.
        // If your storyboard is set up correctly, and the cellIdentifier matches the identifier from your storyboard, then the downcast should never fail. If the downcast does fail, the fatalError() function prints an error message to the console and terminates the app.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gameCellIdentifier, for: indexPath) as? GameTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        // The table view will iterate over each thing in the filteredData
        let game = filteredData[indexPath.row]
        
        cell.gameTitleLabel.text = game.title
        
        // Get these to be the images of the API call
        cell.gameImageView.image = #imageLiteral(resourceName: "joystick")
        
        // Return the cell view
        return cell
    }
    
    // The search bar is dynamic. With each searchText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        if !searchText.isEmpty {
            filteredData = currentGames.filter{ $0.title.localizedCaseInsensitiveContains(searchText) }
        } else {
            filteredData = currentGames
        }
        self.tableViewContent.reloadData()
    }

    // Notification Center Functions
    
    // Will be consumed by the NC --> Messages are sent from the sideMenuViewController on click
//    @objc func showCreateLobby () {
//        performSegue(withIdentifier: "ShowCreateLobby", sender: nil)
//    }
//
//    @objc func showMyLobbies () {
//        performSegue(withIdentifier: "ShowMyLobbies", sender: nil)
//    }
//
//    @objc func showEditProfile () {
//        performSegue(withIdentifier: "ShowEditProfile", sender: nil)
//    }
//
//    @objc func showCreatedLobbies() {
//        performSegue(withIdentifier: "ShowCreatedLobbies", sender: nil)
//    }
    
    @objc func showLoginView () {
        // TODO: Look into this error again
        // Here I am unwinding. Get an error that this is discouraged when going back to root view

        findSignedInUser()
        removeSignedInUserID()

        let alert = UIAlertController(title: "Succesfully Logged Out!", message: "Come back again soon!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.dismiss(animated: true, completion: nil)
        })

        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)

        // Other options
        // self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
    }
    
    // Private functions
    
    private func getData() {
        let realm = try! Realm()
        let returnedGames = realm.objects(Game.self).sorted(byKeyPath: "title")
        for game in returnedGames {
            currentGames.append(game)
        }
    }
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
    }
    
    private func removeSignedInUserID() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userID")
//        UserDefaults.standard.synchronize()
        print("\(String(describing: UserDefaults.standard.string(forKey: "userID")))")
    }
    
    // Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If there is a segue that is labeld as "Lobby Games" AND a tableview cell is selected, pull out the object from the filteredData array that was clicked and then make it equal to the controller attribute
        if segue.identifier == "LobbyGames" {
            if let indexPath = tableViewContent.indexPathForSelectedRow {
                let gameObject = filteredData[indexPath.row]
                let controller = segue.destination as? AvailableLobbyViewController
                controller?.chosenGame = gameObject
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        filteredData = currentGames
        
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        searchBarView.delegate = self
        
        // Navigation Bar Observers - Waiting for an on-click message

        // On load, add the observers to the NC to be listening for a click event!!!
//        NotificationCenter.default.addObserver(self, selector: #selector(showCreateLobby), name: NSNotification.Name("ShowCreateLobby"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showMyLobbies), name: NSNotification.Name("ShowMyLobbies"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showEditProfile), name: NSNotification.Name("ShowEditProfile"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showCreatedLobbies), name: NSNotification.Name("ShowLoginView"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showLoginView), name: NSNotification.Name("ShowLoginView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentGames = [Game]()
        
        getData()
        filteredData = currentGames
        self.tableViewContent.reloadData()
    }
}


