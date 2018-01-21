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
    
    @objc func showLoginView () {
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
    
    var apiKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        filteredData = currentGames
        
        tableViewContent.delegate = self
        tableViewContent.dataSource = self
        searchBarView.delegate = self
        self.title = "Search Games"
        getGameJsonData()
        apiKey = valueForAPIKey(named: "GIANT_BOMB_API")
    }
    
    // Reloads the data inside the table view each time the user goes back to this page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentGames = [Game]()
        
        getData()
        filteredData = currentGames
        self.tableViewContent.reloadData()
    }
    
    let gameApiIds = ["3030-48190", "3030-48320"]
//    let OVERWATCH_GAME_ID = "3030-48190"
//    let STREET_FIGHTER_V_GAME_ID = "3030-48320"
    
    private func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
    
    func getGameJsonData() {
        var i = 0
        print("before the loop")
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
                            createGameObject(gameName: name as! String, imageURL: gameImageUrl, gameID: id)
                            print(name)
                            print(gameImageUrl)
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

//
//{
//    "error": "OK",
//    "limit": 1,
//    "offset": 0,
//    "number_of_page_results": 1,
//    "number_of_total_results": 1,
//    "status_code": 1,
//    "results": {
//        "image": {
//            "icon_url": "https://www.giantbomb.com/api/image/square_avatar/2852990-overwatch.jpg",
//            "medium_url": "https://www.giantbomb.com/api/image/scale_medium/2852990-overwatch.jpg",
//            "screen_url": "https://www.giantbomb.com/api/image/screen_medium/2852990-overwatch.jpg",
//            "screen_large_url": "https://www.giantbomb.com/api/image/screen_kubrick/2852990-overwatch.jpg",
//            "small_url": "https://www.giantbomb.com/api/image/scale_small/2852990-overwatch.jpg",
//            "super_url": "https://www.giantbomb.com/api/image/scale_large/2852990-overwatch.jpg",
//            "thumb_url": "https://www.giantbomb.com/api/image/scale_avatar/2852990-overwatch.jpg",
//            "tiny_url": "https://www.giantbomb.com/api/image/square_mini/2852990-overwatch.jpg",
//            "original_url": "https://www.giantbomb.com/api/image/original/2852990-overwatch.jpg",
//            "image_tags": "All Images,Box Art"
//        },
//        "name": "Overwatch"
//    },
//    "version": "1.0"
//}


