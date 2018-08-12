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
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        donutView.numPlayer = 3
        playerNumLabel.text = "\(donutView.numPlayer)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

