//
//  SearchViewController.swift
//  favour
//
//  Created by Ray Cove on 23/01/2018.
//  Copyright © 2018 Ray Cove. All rights reserved.
//

import UIKit

var searchedtext = String()

struct SearchDataset {
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

var SearchDataSet: [SearchDataset] = []

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.endEditing(true)
        SearchDataSet.removeAll()

        // Do any additional setup after loading the view.
    }
    
    func fetchapiresults(){
        
        SearchDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=favours&search=\(searchedtext)"
        
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
                        
                        let dataToAdd: SearchDataset = SearchDataset(id: thing["id"]!,userid: thing["userid"]!, title: thing["title"]!, description: thing["description"]!, username: thing["username"]!, imageid: thing["imageid"]!, views: thing["views"]!, date: thing["date"]!, applications: thing["applications"]!)
                        
                        SearchDataSet.append(dataToAdd)
                        
                    }
                    
                    print(SearchDataSet)
                    self.tableView.reloadData()
                    // make sure there is data in the json before setting it or it will crash
                    
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
            
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var timer = Timer()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SearchViewController.output), userInfo: searchText, repeats: false)
        
    }
    
    @objc func output(){
        print("hello")
        if timer.userInfo != nil {
            searchedtext = timer.userInfo as! String
        fetchapiresults()
            self.searchBar.endEditing(false)
        
            
        }
        timer.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchDataSet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("favoursTableViewCell", owner: self, options: nil)?.first as! favoursTableViewCell
        cell.tablelabel.text = SearchDataSet[indexPath.row].title
        cell.tabletext.text = SearchDataSet[indexPath.row].description
        let useridInt = Int(SearchDataSet[indexPath.row].userid)
        cell.profileimage.tag = useridInt!
        cell.viewcount.text = SearchDataSet[indexPath.row].views
        
        
        
        let datetobeconverted = Double(SearchDataSet[indexPath.row].date)
        let date = Date(timeIntervalSince1970: datetobeconverted!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        
        let localDate = dateFormatter.string(from: date)
        
        
        cell.favourdate.text = localDate
        cell.applicationscount.text = SearchDataSet[indexPath.row].applications
        
        
        cell.profileimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/\(SearchDataSet[indexPath.row].imageid).jpg"))
        
        
        
        cell.username.text = SearchDataSet[indexPath.row].username
        
        cell.profileimage.layer.borderWidth = 0
        cell.profileimage.layer.masksToBounds = false
        cell.profileimage.contentMode = .scaleAspectFill
        cell.profileimage.layer.cornerRadius = 15
        cell.profileimage.clipsToBounds = true
        
        return(cell)
    }
    


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
    selectedFavour = SearchDataSet[indexPath.row].id
    
    subviewviewcontrollername = "FavourView"
    wassubview = true
    let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
    tabViewController.modalPresentationStyle = .overCurrentContext
    present(tabViewController, animated: true, completion: nil)
    
    
    
}


}
