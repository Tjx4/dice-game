//
//  DashboardViewController.swift
//  Dice game
//
//  Created by Tshepo Mahlaula on 2020/04/06.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var lblLuckyNumber: UILabel!
    @IBOutlet weak var imgDice: UIImageView!
    
    let child = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniRound()
    }
    
    @IBAction func onRollClikced(_ sender: Any) {
        
        imgDice.rotate(180, 0)
    }
    
    func iniRound(){
        
        showLoading()

        do{
          let round = try fetchRoundJsonAsync()

          let luckyNumber = round?.luckyNumber
          let title = "Lucky number"
          let message = "Lucky number is \(luckyNumber)"

          lblLuckyNumber.text = "\(luckyNumber)"
          // showUIAlert(self, title, message, "No", "Yes")
          
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
