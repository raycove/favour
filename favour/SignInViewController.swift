//
//  SignInViewController.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit
var userEmail = String()
var userName = String()
var userID = String()
var userAuth = false
var userImageId = String()
class SignInViewController: UIViewController {
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        let emailentered = emailtext.text as! String
        let passwordentered = passwordtext.text as! String
       let APIURL = "http://evorbe.com/favour/api.php?request=signin&email=\(emailentered)&password=\(passwordentered)"
// let APIURL = "http://evorbe.com/favour/api.php?request=signin&email=evorbenetworks@gmail.com&password=password"
        print(APIURL)
        var request = URLRequest(url: URL(string: APIURL)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("ERROR")
            }
            else{
                
                do {
                    
                    
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
                    
                    // make sure there is data in the json before setting it or it will crash
                    
                    if let jsondata = json as NSDictionary? {
                        
                        if (jsondata["email"] as? String) == nil {
                          
                                userAuth = false
                            
                        }else{
                            userAuth = true
                        userEmail = jsondata["email"] as! String
                        userName = jsondata["username"] as! String
                        userID = jsondata["id"] as! String
                        userImageId = jsondata["imageid"] as! String
                      
                       }
                        
                        self.hasSignedIn()
                        print(jsondata)
                        
                        
                        
                    }
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
    }

}
               task.resume()
}
    
    func hasSignedIn() {
        if userAuth == true {
        performSegue(withIdentifier: "SignInSegue", sender: self)
        }else{
         
        }
    }
 
    
    
}
