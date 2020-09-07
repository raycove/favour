//
//  favoursViewController.swift
//  favour
//
//  Created by Ray Cove on 30/09/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit


var profileImage:UIImage? = nil
struct FavoursDataset {
    var id: String
    var userid: String
    var title = String()
    var description = String()
    var username = String()
    var imageid = String()
    var views = String()
    var date = String()
    var applications = String()
}
var selectedFavour = String()
var FavoursDataSet: [FavoursDataset] = []

struct FavoursProfileimages {
var id: String
var image: UIImage
}

var FavoursProfileImages: [FavoursProfileimages] = []



class favoursViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  
    

    @IBOutlet weak var profilebutton: UIButton!
    
    @IBAction func viewProfile(_ sender: Any) {
        userprofileid = userID
    
        subviewviewcontrollername = "ProfileView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilebutton.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/\(userImageId).jpg"), for: .normal)
    
        
       
    
        profilebutton.layer.borderWidth = 0
        profilebutton.layer.masksToBounds = false
        profilebutton.imageView?.contentMode = .scaleAspectFill
        
       profilebutton.layer.cornerRadius = profilebutton.frame.height/2
        profilebutton.clipsToBounds = true
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.fetchapiresults()
        
        
        
        }
    
    func fetchapiresults(){
        
        FavoursDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=favours"
        
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
                    // make sure there is data in the json before setting it or it will crash
                    
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
            
        }
        task.resume()
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
            let useridInt = Int(FavoursDataSet[indexPath.row].userid)
            cell.profileimage.tag = useridInt!
            cell.viewcount.text = FavoursDataSet[indexPath.row].views
            
            
            
            let datetobeconverted = Double(FavoursDataSet[indexPath.row].date)
            let date = Date(timeIntervalSince1970: datetobeconverted!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            
            let localDate = dateFormatter.string(from: date)
            
            
            cell.favourdate.text = localDate
            cell.applicationscount.text = FavoursDataSet[indexPath.row].applications
         
            
            cell.profileimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/\(FavoursDataSet[indexPath.row].imageid).jpg"))
 
        
            
            cell.username.text = FavoursDataSet[indexPath.row].username
            
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
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)

           
       
    }

    

}


