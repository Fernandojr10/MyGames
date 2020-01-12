//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by zupper on 11/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var nameGame: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var console: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with game: Game) {
        nameGame.text = game.title ?? ""
        console.text = game.console?.name ?? ""
        
        if let image = game.cover as? UIImage{
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "noCover")
        }
    }
}
