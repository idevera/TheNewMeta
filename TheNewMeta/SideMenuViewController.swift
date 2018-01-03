//
//  SideMenuViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        // Each table row has an index that it represents
        switch indexPath.row {
            // Emits a message for the Notifcation Center to listen to !!!
            case 0: NotificationCenter.default.post(name: NSNotification.Name("ShowCreateLobby"), object: nil)
            case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowMyLobbies"), object: nil)
            case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowEditProfile"), object: nil)
            default: break
        }
    }
}
