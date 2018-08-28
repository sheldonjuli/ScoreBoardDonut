//
//  ViewController.swift
//  Score Board Donut
//
//  Created by Li Ju on 2018-08-11.
//  Copyright © 2018 Li Ju. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Variables
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
    
    // MARK: Constants
    private struct Constants {
        static let playerNumLabelFontToViewWidthRatio: CGFloat = 0.065
        static let stopWatchLabelFontToViewWidthRatio: CGFloat = 0.09
    }
    
    private var playerNumLabelFontSize: CGFloat {
        return self.view.frame.width * Constants.playerNumLabelFontToViewWidthRatio
    }
    
    private var stopWatchLabelFontSize: CGFloat {
        return self.view.frame.width * Constants.stopWatchLabelFontToViewWidthRatio
    }

    
    // MARK: System functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNumLabel.font = playerNumLabel.font.withSize(playerNumLabelFontSize)
        stopWatchLabel.font = stopWatchLabel.font.withSize(stopWatchLabelFontSize)

        updateDonutView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(updatePlayerScore))
        donutView.addGestureRecognizer(tapRecognizer)
    }
    
    
    // MARK: Score functions
    @IBAction func editPlayerNum(_ sender: UIButton) {
        
        if sender == PlayerNumDownButton, numPlayer > 1 {
            numPlayer -= 1
        } else if sender == playerNumUpButton {
            if numPlayer < 4 {
                numPlayer += 1
            }
        }
    }
    
    @IBAction func resetScore(_ sender: Any) {
        game.resetPlayerScore()
        updateDonutView()
    }
    
    private func determineSection(tappedPoint: CGPoint) -> (Int, Int) {

        let donutViewRect = donutView.bounds
        let tapDis = findDistanceBetween(pointA: tappedPoint, pointB: donutViewRect.center)
        let sideLen = findLongerSideLen(rect: donutViewRect)
        
        // If tapped in the circle
        if sideLen / 4 <= tapDis, tapDis <= sideLen / 2 {

            // find degree of tapped points in the coordinate system
            let sectionDegreeWidth = findSectionWidth(numPlayer: numPlayer)
            let startAngle = findStartAngle(numPlayer: numPlayer, section: 0)
            var degreeOffset = findDegreeOffsetBetween(pointA: tappedPoint, pointB: donutViewRect.center)
            degreeOffset = degreeOffset < startAngle ? degreeOffset + (2 * .pi) : degreeOffset
            degreeOffset -= startAngle

            let section = (degreeOffset / sectionDegreeWidth).rounded(.down)
            let operation = ((degreeOffset / (0.5 * sectionDegreeWidth)).rounded(.down)).truncatingRemainder(dividingBy: 2)
            let scoreChange = operation == 0 ? 1 : -1
            return (Int(section), scoreChange)
        }

        return (0, 0)
    }
    
    private func updateDonutView() {
        if game.players.count > 0 {
            donutView.scores = [Int]()
            for playerIndex in 0...game.players.count - 1 {
                donutView.scores.append(game.players[playerIndex].score)

            }
        }
    }
    
    @objc private func updatePlayerScore(_ sender: UITapGestureRecognizer) {
        let tappedPoint = sender.location(in: donutView)
        let (section, scoreChange) = determineSection(tappedPoint: tappedPoint)
        game.players[section].score += scoreChange
        updateDonutView()
    }
    

    //MARK: Timer functions
    @IBAction func playPauseTimer(_ sender: AnyObject) {
        if !isPlay {
            unowned let weakSelf = self
            
            stopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateTimer, userInfo: nil, repeats: true)

            RunLoop.current.add(stopWatch.timer, forMode: .commonModes)
            
            isPlay = true
            changeButton(playPauseButton, imageName: "timer-pause.png", titleColor: UIColor.red)
        } else {
            
            stopWatch.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, imageName: "timer-play.png", titleColor: UIColor.green)
        }
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        stopWatch.timer.invalidate()
        stopWatch.counter = 0.0
        stopWatchLabel.text = "00:00"
        isPlay = false
        changeButton(playPauseButton, imageName: "timer-play.png", titleColor: UIColor.green)
    }

    fileprivate func changeButton(_ button: UIButton, imageName: String, titleColor: UIColor) {
        button.setImage(UIImage(named: imageName), for: UIControlState())
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

}

fileprivate extension Selector {
    static let updateTimer = #selector(ViewController.updateTimer)
}


