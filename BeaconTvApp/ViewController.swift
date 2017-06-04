//
//  ViewController.swift
//  BeaconTvApp
//
//  Created by Jan-Hendrik Popp on 06.05.17.
//  Copyright © 2017 Jan-Hendrik Popp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var playerNameLeft: UILabel!
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var roundResultLeft: UILabel!
    
    @IBOutlet weak var playerNameRight: UILabel!
    @IBOutlet weak var imageRight: UIImageView!
    @IBOutlet weak var roundResultRight: UILabel!
    
    var gameId:Int = 0
    var gameComplete:Bool = false;
    var playerLeftId:Int = 0;
    var playerRightId:Int = 0;
    var showedResult:Bool = false;
    
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        resetView()
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.gameLoop),userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameLoop() -> Void {
        if (gameComplete) {
            if (!showedResult) {
                loadGameResultLeft()
                loadGameResultRight()
                showedResult = true;
            } else {
                resetView()
            }
        } else {
            if (gameId == 0) {
                loadNewGame()
            } else {
                loadGame(gameId: gameId);
            }
        }
    }
    
    func updateGame(dictionary:[String: Any]) -> Void {
        if let firstUser = dictionary["firstUser"] as? [String: Any] {
            if let leftName = firstUser["name"] as? String {
                self.playerNameLeft.text = leftName
            }
            if let leftId = firstUser["id"] as? Int {
                self.playerLeftId = leftId
            }
            if let figureLeft = dictionary["firstFigure"] as? String {
                if (figureLeft == "SCISSOR") {
                    self.imageLeft.image = #imageLiteral(resourceName: "scissor.png")
                } else if (figureLeft == "ROCK") {
                    self.imageLeft.image = #imageLiteral(resourceName: "rock.png")
                } else {
                    self.imageLeft.image = #imageLiteral(resourceName: "paper.jpg")
                }
            }
        }
        if let rightUser = dictionary["secondUser"] as? [String: Any] {
            if let rightName = rightUser["name"] as? String {
                self.playerNameRight.text = rightName
            }
            if let rightId = rightUser["id"] as? Int {
                self.playerRightId = rightId
            }
            if let figureRight = dictionary["secondFigure"] as? String {
                if (figureRight == "SCISSOR") {
                    self.imageRight.image = #imageLiteral(resourceName: "scissor.png")
                } else if (figureRight == "ROCK") {
                    self.imageRight.image = #imageLiteral(resourceName: "rock.png")
                } else {
                    self.imageRight.image = #imageLiteral(resourceName: "paper.jpg")
                }
                self.imageLeft.isHidden = false;
                self.imageRight.isHidden = false;
            }
            self.gameComplete = true;
        }
    }
    
    
    func loadGame(gameId:Int) -> Void {
        let url = NSURL(string: "https://beacon-backend.herokuapp.com/api/1/game/" + String(gameId))
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            
            guard error == nil && data != nil else {
                print("error", error!)
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if httpStatus!.statusCode == 200
            {
                if data?.count != 0
                {
                    let responString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async() {
                        self.updateGame(dictionary: (responString as? [String: Any])!)
                    }
                }
                else{
                    print("No got data from URL")
                }
            }
            else
            {
                print("error httpstatus code is ", httpStatus!.statusCode)
            }
        }
        
        task.resume()
    }
    
    func loadGameResultLeft() -> Void {
        let url = NSURL(string: "https://beacon-backend.herokuapp.com/api/1/game/" + String(gameId) + "/" + String(playerLeftId))
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            
            guard error == nil && data != nil else {
                print("error", error!)
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if httpStatus!.statusCode == 200
            {
                if data?.count != 0
                {
                    let responString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async() {
                        let dictionary = responString as? [String: Any]
                        if let result = dictionary?["result"] as? String {
                            if (result == "LOOSE") {
                                self.roundResultLeft.text = "Verloren"
                            } else if (result == "WIN") {
                                self.roundResultLeft.text = "Gewonnen"
                            } else {
                                self.roundResultLeft.text = "Unentschieden"
                            }
                            self.roundResultLeft.isHidden = false;
                        }
                    }
                }
                else{
                    print("No got data from URL")
                }
            }
            else
            {
                print("error httpstatus code is ", httpStatus!.statusCode)
            }
        }
        
        task.resume()
    }
    
    func loadGameResultRight() -> Void {
        let url = NSURL(string: "https://beacon-backend.herokuapp.com/api/1/game/" + String(gameId) + "/" + String(playerRightId))
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            
            guard error == nil && data != nil else {
                print("error", error!)
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if httpStatus!.statusCode == 200
            {
                if data?.count != 0
                {
                    let responString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async() {
                        let dictionary = responString as? [String: Any]
                        if let result = dictionary?["result"] as? String {
                            if (result == "LOOSE") {
                                self.roundResultRight.text = "Verloren"
                            } else if (result == "WIN") {
                                self.roundResultRight.text = "Gewonnen"
                            } else {
                                self.roundResultRight.text = "Unentschieden"
                            }
                            self.roundResultRight.isHidden = false;
                        }
                    }
                }
                else{
                    print("No got data from URL")
                }
            }
            else
            {
                print("error httpstatus code is ", httpStatus!.statusCode)
            }
        }
        
        task.resume()
    }
    
    func loadNewGame() -> Void {
        let url = NSURL(string: "https://beacon-backend.herokuapp.com/api/1/game/newGame")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            
            guard error == nil && data != nil else {
                print("error", error!)
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if httpStatus!.statusCode == 200
            {
                if data?.count != 0
                {
                    let responString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    DispatchQueue.main.async() {
                        let dictionary = responString as? [String: Any]
                        if let id = dictionary?["id"] as? Int {
                            self.gameId = id;
                        }
                    }
                }
                else{
                    print("No got data from URL")
                }
            }
            else
            {
                print("error httpstatus code is ", httpStatus!.statusCode)
            }
        }
        
        task.resume()
    }

    
    func resetView() -> Void {
        playerNameLeft.text = "warten..."
        imageLeft.isHidden = true
        roundResultLeft.isHidden = true
        playerNameRight.text = "warten..."
        imageRight.isHidden = true
        roundResultRight.isHidden = true
        gameComplete = false;
        gameId = 0;
        showedResult = false;
    }
    
    func setBackground() -> Void {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "logo.png")?.draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            self.view.contentMode = .scaleAspectFit
        } else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
    }
    

}

