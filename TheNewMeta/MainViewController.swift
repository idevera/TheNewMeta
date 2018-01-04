//
//  MainViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func clickHamburger() {
        print("TOGGLE SIDE MENU")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On load, add the observers to the NC
        NotificationCenter.default.addObserver(self, selector: #selector(showCreateLobby), name: NSNotification.Name("ShowCreateLobby"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMyLobbies), name: NSNotification.Name("ShowMyLobbies"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showEditProfile), name: NSNotification.Name("ShowEditProfile"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(showLoginView), name: NSNotification.Name("ShowLoginView"), object: nil)

    }
    
    // Will be consumed by the NC
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
}
