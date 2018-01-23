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
    
    var currentGames = [Game]()
    var filteredData = [Game]()
    private var signedInUser = User()
    let gameCellIdentifier = "gameTitleCell"
    lazy var gradient: CAGradientLayer = [
        UIColor(hex: "#FD4340"),
        UIColor(hex: "#CE2BAE")
        ].gradient { gradient in
            gradient.speed = 1
            gradient.timeOffset = 1
            gradient.frame = self.view.bounds
            return gradient
    }
    
    // Outlets
    
    @IBOutlet weak var tableViewContent: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBAction func logoutButton(_ sender: Any) {
        showLoginView()
    }
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.insertSublayer(gradient, at: 0)

        // Get Data from the Realm Database
        getData()
        filteredData = currentGames
        
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        searchBarView.delegate = self
        
        tableViewContent.estimatedRowHeight = 160
        tableViewContent.rowHeight = UITableViewAutomaticDimension
        self.title = "Games"
        
        // Tap gesture to exit keyboard after tap
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If there is a segue that is labeled as "Lobby Games" AND a tableview cell is selected, pull out the object from the filteredData array that was clicked and then make it equal to the controller attribute
        print("I am in the segue, before the identifier")

        if segue.identifier == "LobbyGamesID" {
            if let indexPath = tableViewContent.indexPathForSelectedRow {
                print(indexPath)
                let gameObject = filteredData[indexPath.row]
                let controller = segue.destination as? AvailableLobbyViewController
                controller?.chosenGame = gameObject
            }
        }
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
        let currentImageURL = URL(string: game.imageURL)
//        print("This is the game object URL: ", game.imageURL)
        // Make images load asynchronously from the main UI thread
        // https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: currentImageURL!) {
                DispatchQueue.main.async {
                    cell.gameImageView.image = UIImage(data: data)
                }
            }
        }
        
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
        print("This is the signed in user ID:")
        print("\(String(describing: UserDefaults.standard.string(forKey: "userID")))")
    }
    
    @objc private func showLoginView () {
        findSignedInUser()
        removeSignedInUserID()
        
        let alert = UIAlertController(title: "Succesfully Logged Out!", message: "Come back again soon!", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
//    @objc private func dismissKeyboard() {
//        // Causes the view (or one of its embedded text fields to resign the first responder status.
//        view.endEditing(true)
//    }
}



