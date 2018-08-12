//
//  ViewController.swift
//  Score Board Donut
//
//  Created by Li Ju on 2018-08-11.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var donutView: DonutView!
    @IBOutlet weak var playerNumLabel: UILabel!
    @IBOutlet weak var playerNumUpButton: UIButton!
    @IBOutlet weak var PlayerNumDownButton: UIButton!
    
    
    private lazy var game: Game = Game(numPlayer: numPlayer)
    
    var numPlayer: Int = 4 {
        didSet {
            donutView.numPlayer = numPlayer
            playerNumLabel.text = "\(numPlayer)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editPlayerNum(_ sender: UIButton) {
        
        if sender == PlayerNumDownButton, numPlayer > 1 {
            numPlayer -= 1
        } else if sender == playerNumUpButton {
            if numPlayer < 4 {
                numPlayer += 1
            }
        }
    }
}

