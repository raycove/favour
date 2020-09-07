//
//  CreateFavourViewController.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit
import CoreLocation
var createdFavour = ""


class CreateFavourViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var favourtitle: UITextField!
    @IBOutlet weak var favourdescription: UITextView!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func cancelcreation(_ sender: Any) {
        
        subviewviewcontrollername = "HomeView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
        
    }
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
      
        userLat = String(format: "%.6f", location.coordinate.latitude)
        userLong = String(format: "%.6f", location.coordinate.longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func create(_ sender: Any) {
        self.createfavour()
    }
    
    func stopanimating() {
        print("stop animating function running")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
      
    func createfavour(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        
        let json: [String: Any] = ["userid":userID, "title":favourtitle.text as! String, "description":favourdescription.text as! String, "latitude":userLat, "longitude":userLong]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=createfavour")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsondatatosend
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
          
         
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if responseJSON["result"] as! String == "true" {
                   
                   
                    createdFavour = responseJSON["favourid"] as! String
                    print(createdFavour)
                    
                    DispatchQueue.main.async {
                        if createdFavour != "" {
                            self.stopanimating()
                         
                            subviewviewcontrollername = "FavourView"
                            wassubview = true
                            let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
                            tabViewController.modalPresentationStyle = .overCurrentContext
                            self.present(tabViewController, animated: true, completion: nil)
                        
                    }
                    }
                    
                }else{
                  
                    print("failed")
                    
                }
        }
        }
        
        
        task.resume()
       
       
        // Do any additional setup after loading the view.
    }
  

}
