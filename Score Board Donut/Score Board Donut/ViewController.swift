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

    @IBOutlet weak var stopWatchLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var resetTimeButton: UIButton!
    @IBOutlet weak var resetScoreButton: UIButton!
    
    fileprivate let stopWatch: Stopwatch = Stopwatch()
    fileprivate var isPlay: Bool = false

    var numPlayer: Int = 4 {
        didSet {
            donutView.numPlayer = numPlayer
            playerNumLabel.text = "\(numPlayer)"
            Player.restartPlayerCount()
        }
    }

    private lazy var game: Game = Game(numPlayer: numPlayer)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDonutView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatePlayerScore))
        
        donutView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func updatePlayerScore(_ sender: UITapGestureRecognizer) {
        let tappedPoint = sender.location(in: donutView)
        print(tappedPoint)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateDonutView() {
        if game.players.count > 0 {
            donutView.scores = [Int]()
            for playerIndex in 0...game.players.count - 1 {
                donutView.scores.append(game.players[playerIndex].score)

            }
        }
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
    
    @IBAction func playPauseTimer(_ sender: AnyObject) {
        if !isPlay {
            unowned let weakSelf = self
            
            stopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateTimer, userInfo: nil, repeats: true)

            RunLoop.current.add(stopWatch.timer, forMode: .commonModes)
            
            isPlay = true
            changeButton(playPauseButton, title: "Stop", titleColor: UIColor.red)
        } else {
            
            stopWatch.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, title: "Start", titleColor: UIColor.green)
        }
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        stopWatch.timer.invalidate()
        stopWatch.counter = 0.0
        stopWatchLabel.text = "00:00"
        isPlay = false
        changeButton(playPauseButton, title: "Start", titleColor: UIColor.green)
    }

    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
    }

    @objc func updateTimer() {
        stopWatch.counter = stopWatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopWatch.counter / 60))"
        if (Int)(stopWatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopWatch.counter / 60))"
        }
        
        var seconds: String = String(Int(stopWatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopWatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        stopWatchLabel.text = minutes + ":" + seconds
    }

    @IBAction func resetScore(_ sender: Any) {
        game.resetPlayerScore()
        updateDonutView()
    }
}

fileprivate extension Selector {
    static let updateTimer = #selector(ViewController.updateTimer)
}

