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
    
    private var round: Int = 1
    private var luckyNumber: Int = 0
    
    let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
caller()
    }
    
// This is the start of the testing
    
    //Todo: learn more on enums
    enum Gender: String{
        case Male = "Man"
        case Female = "Women"
    }
    
    class User{
        init(_ name: String? , _ age: Int, _ gender: Gender?){
            self.name = name
            self.age = age
            self.gender = gender
        }
        
        var name: String? = nil
        var age: Int = 0
        var gender: Gender? = nil
    }
    
    private func createUser(username name: String, age: Int, _ gender: Gender) -> User{
        return User(name, age, gender)
    }
    
    private func caller() {
        let surname = "Baloyi"
        let age = 31
        let gender = Gender.Male
        
        let myUser = createUser(username: "Tshepo \(surname)", age: age, gender)
        
        let message = "Name is \(myUser.name), Age is \(myUser.age) and you are a \(myUser.gender?.rawValue)"
        
        print(message)
        
    }
    
    
// This is the end of the testing
    
    
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
        
        let diceImage = { () -> String in
            switch rolledNumber {
            case 1:
                return "di_1"
            case 2:
                return "di_2"
            case 3:
                return "di_3"
            case 4:
                return "di_4"
            case 5:
                return "di_5"
            case 6:
                return "di_6"
            default:
                return ""
            }
        }
        
        imgDice.image = UIImage(named: diceImage())
        
        if rolledNumber == luckyNumber {
            round += 1
            
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

        lblRound.text = "\(round)"
        
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
