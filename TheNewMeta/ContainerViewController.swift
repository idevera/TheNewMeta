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
    
    // This outlet is linked to the constant constraint
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var sideMenuOpen = false
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            // This will hide the menu
            sideMenuConstraint.constant = -200
        } else {
            // This will show the menu?
            sideMenuConstraint.constant = 0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is the containerVC ViewDidLoad()")
        // Adding an observer to the NotifcationCenter and all its attributes. I think the NotificationCenter is listening to any Notificaton that has the name of ToggleSideMenu   
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
}
