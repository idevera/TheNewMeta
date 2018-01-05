//
//  AfterLoginViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ContainerViewController : UIViewController {
    
    var sideMenuOpen = false
    
    // This outlet is linked to the constant constraint
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            // This will hide the menu
            sideMenuConstraint.constant = -200
            sideMenuOpen = false
        } else {
            // This will show the menu
            sideMenuConstraint.constant = 0
            sideMenuOpen = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding an observer to the NotifcationCenter and all its attributes. I think the NotificationCenter is listening to any Notificaton that has the name of ToggleSideMenu2
        // See the MainViewController for the NotificationCenter.default.post "message"
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
}
