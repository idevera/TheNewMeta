//
//  GameCell.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/5/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit
import RealmSwift

class GameCell: UITableViewCell {

    @IBOutlet weak var gameLabel: UILabel!

    var gameTitle: String? {
        didSet {
            gameLabel.text = gameTitle
        }
    }
}
