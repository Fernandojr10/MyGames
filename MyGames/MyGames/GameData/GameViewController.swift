//
//  GameViewController.swift
//  MyGames
//
//  Created by zupper on 11/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    

    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbText: UILabel!
    @IBOutlet weak var lbReleaseData: UILabel!
    
    @IBOutlet weak var ivCover: UIImageView!
    
    var game : Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbText.text = game.title
            lbConsole.text = game.console?.name
              if let releaseData = game.realeseDate{
                  let formatter = DateFormatter()
                  formatter.dateStyle = .long
                  formatter.locale = Locale(identifier: "pt-BR")
                  lbReleaseData.text = "Lançamento: " + formatter.string(from: releaseData)
               }
              if let image = game.cover as? UIImage{
                  ivCover.image = image
              }else{
                  ivCover.image = UIImage(named: "noCoverFull")
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddViewController
        vc.game = game
    }
        // Do any additional setup after loading the view.
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


