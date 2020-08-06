//
//  DashboardViewController.swift
//  Dice game
//
//  Created by Tshepo Mahlaula on 2020/04/06.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var lblRound: UILabel!
    @IBOutlet weak var lblLuckyNumber: UILabel!
    @IBOutlet weak var lblRollMessage: UILabel!
    @IBOutlet weak var imgDice: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    private var luckyNumber: Int = 0
    
    let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        iniRound()
    }
    
    @IBAction func onRollClikced(_ sender: Any) {
        imgDice.rotate(self as UIViewController, 180, 1, 0)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop...")
        
        let rolledNumber = Int.random(in: 1...6)
        
        if rolledNumber == luckyNumber {
            let title = "You win"
            let message = "\(rolledNumber) is your lucky number you've won this round, play next round "
            
        
           showSingleActionUIAlert(self, title, message, "Play again", leftActionHandler:{ (action) -> Void in
                self.iniRound()
            })
        }
        else{
            lblRollMessage.text = "You rolled a \(rolledNumber) please try again"
        }
    }
    
    func iniRound(){
        showLoading()

        do{
          let round = try fetchRoundJsonAsync()
            luckyNumber = round?.luckyNumber ?? 0
        
         lblLuckyNumber.text = "\(luckyNumber)"
          
        } catch {
           print("Failed !!!!!!!!!!!!!!", error)
        }


        self.hideLoading()
    }
    
    enum Networerror: Error{
        case url
        case statusCode
        case generic
    }
    
    fileprivate func fetchRoundJsonAsync() throws -> RoundModel? {
        let urlString = HOST+""+GET_LUCKY_NUMBER
        print(urlString)
                
        guard let url = URL(string: urlString) else {
            throw Networerror.url
        }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (d, resp, err) in
            data = d
            response = resp
            error = err
            
            semaphore.signal()
        }.resume()
        
       _ = semaphore.wait(timeout: .distantFuture)
        
        if let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode > 200 {
            throw Networerror.statusCode
        }
        
        if error != nil{
            throw Networerror.generic
        }
        
        return try JSONDecoder().decode(RoundModel.self,
        from: data!)
    }

    fileprivate func showLoading() {
         addChild(child)
         child.view.frame = view.frame
         view.addSubview(child.view)
         child.didMove(toParent: self)
     }
     
     fileprivate func hideLoading() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
         }
     }
}
