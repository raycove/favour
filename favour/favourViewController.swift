//
//  favourViewController.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

var currentuseridfavour = String()

class favourViewController: UIViewController {

    @IBOutlet weak var applicationtext: UITextView!
    @IBOutlet weak var descriptiontext: UITextView!
    @IBOutlet weak var titlelabel: UITextField!
    @IBOutlet weak var applicationconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var profileImage: UIButton!
    
    @IBAction func profileViewButton(_ sender: Any) {
        userprofileid = currentuseridfavour
        
        subviewviewcontrollername = "ProfileView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
        
        
    }
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var APIURL = String()
        if createdFavour != "" {
            
         APIURL = "http://evorbe.com/favour/api.php?request=favours&id=\(createdFavour)"
            createdFavour = ""
        }else{
        APIURL = "http://evorbe.com/favour/api.php?request=favours&id=\(selectedFavour)"
        }
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
                    
                    
                    let jsondata = try JSONSerialization.jsonObject(with: data!) as? [String:String]
                    
                    print(jsondata)
                  
                    // make sure there is data in the json before setting it or it will crash
                    self.descriptiontext.text = jsondata?["description"]
                    self.titlelabel.text = jsondata?["title"]
                    self.profileUsername.text = jsondata?["username"]
                    currentuseridfavour = (jsondata?["userid"])!
                    
                    self.profileImage.layer.borderWidth = 0
                    self.profileImage.layer.masksToBounds = false
                    self.profileImage.layer.cornerRadius = 25
                    self.profileImage.clipsToBounds = true
                    
                    
                    
                    
                    let profileuserid = jsondata?["userid"]
            
                   
                    
                    self.profileImage.sd_setBackgroundImage(with: URL(string: "http://evorbe.com/favour/uploads/" + jsondata!["imageid"]! + ".jpg"), for: .normal)
                    
                                
                                
                                
                                
                          
                
                                
                    
                    
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
            
        }
        task.resume()
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func Apply(_ sender: Any) {
        applicationconstraint.constant = 0
    }
    
    func stopanimating() {
        print("stop animating function running")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    @IBAction func Send(_ sender: Any) {
        
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        

    
   
        applicationconstraint.constant = -1000
        
        let json: [String: Any] = ["userid":userID, "message":applicationtext.text, "favourid":selectedFavour]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=createapplication")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsondatatosend
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            print("this part")
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if responseJSON["result"] as! String == "true" {
                    print("uploaded")
                    self.stopanimating()
                }else{
                    print(responseJSON["result"])
                    self.stopanimating()
                }
            }
        }
        
        
        task.resume()
        
    }
    @IBAction func cancelApplication(_ sender: Any) {
        
        applicationconstraint.constant = -1000
        applicationtext.text = ""
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
