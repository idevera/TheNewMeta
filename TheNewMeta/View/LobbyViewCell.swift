//
//  LobbyViewCell.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/8/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class LobbyViewCell: UITableViewCell {
    @IBOutlet weak var gamerTagLabel: UILabel!
    @IBOutlet weak var numPlayersLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
}
