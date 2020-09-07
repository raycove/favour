//
//  nearbyViewController.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


var userLatOld = userLat
var userLongOld = userLong
var locationset = "0"
var hassearched = "0"
class nearbyViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if locationset == "0" {
            if FavoursDataSet.count != 0 {
            locationset = "1"
            }else{
                locationset = "1"
            FavoursDataSet.removeAll()
            fetchapiresults()
            }
            
        }
        
        userLat = String(format: "%.6f", location.coordinate.latitude)
        userLong = String(format: "%.6f", location.coordinate.longitude)
        
       
        
        
    }
  
 var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoursDataSet.removeAll()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        hassearched = "0"
        fetchapiresults()
        locationset = "0"
      
    }
    
   
    

    
    @objc func refresh(sender:AnyObject) {
        hassearched = "0"
        fetchapiresults()
    }
    
    
    
   
    
    func fetchapiresults(){
        FavoursDataSet.removeAll()
        
        
        if userLong == "" || userLat == "" {
            locationset = "0"
            print("this is what is happeing")
        
        }else{
        
            if hassearched == "0"{
                hassearched = "1"
        let APIURL = "http://evorbe.com/favour/api.php?request=favours&lat=\(userLat)&long=\(userLong)"
        
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
                    
                    
                    let jsondata = try JSONSerialization.jsonObject(with: data!) as? [[String:String]]
                    
                    
                    
                    for thing in jsondata!{
                        print(thing)
                        
                        let dataToAdd: FavoursDataset = FavoursDataset(id: thing["id"]!,userid: thing["userid"]!, title: thing["title"]!, description: thing["description"]!, username: thing["username"]!, imageid: thing["imageid"]!, views: thing["views"]!, date: thing["date"]!, applications: thing["applications"]!)
                        
                        FavoursDataSet.append(dataToAdd)
                        
                    }
                    
                    print(FavoursDataSet)
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    // make sure there is data in the json before setting it or it will crash
                    
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
            
        }
        task.resume()
            }}
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if FavoursDataSet.count == 0 {
            return 1
        }else{
            return FavoursDataSet.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        
        if FavoursDataSet.count == 0 {
            let cell = Bundle.main.loadNibNamed("favoursTableViewCell", owner: self, options: nil)?.first as! favoursTableViewCell
            cell.tablelabel.text = "There Are No Favours"
            return(cell)
            
        }else{
            let cell = Bundle.main.loadNibNamed("favoursTableViewCell", owner: self, options: nil)?.first as! favoursTableViewCell
            
            cell.tablelabel.text = FavoursDataSet[indexPath.row].title
            cell.tabletext.text = FavoursDataSet[indexPath.row].description
            cell.username.text = FavoursDataSet[indexPath.row].username
             cell.profileimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/" + FavoursDataSet[indexPath.row].imageid + ".jpg"))
            
            cell.viewcount.text = FavoursDataSet[indexPath.row].views
            
            
            
            let datetobeconverted = Double(FavoursDataSet[indexPath.row].date)
            let date = Date(timeIntervalSince1970: datetobeconverted!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            
            let localDate = dateFormatter.string(from: date)
            
            
            cell.favourdate.text = localDate
            cell.applicationscount.text = FavoursDataSet[indexPath.row].applications
            
            
            cell.profileimage.layer.borderWidth = 0
            cell.profileimage.layer.masksToBounds = false
            cell.profileimage.contentMode = .scaleAspectFill
            cell.profileimage.layer.cornerRadius = 15
            cell.profileimage.clipsToBounds = true
            
            return(cell)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedFavour = FavoursDataSet[indexPath.row].id
        
        subviewviewcontrollername = "FavourView"
        wassubview = true
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        self.present(tabViewController, animated: true, completion: nil)
        
        
    }
}


