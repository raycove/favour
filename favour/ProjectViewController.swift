//
//  ProjectViewController.swift
//  favour
//
//  Created by Ray Cove on 02/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

struct ProjectDataset {
    var id: String
    var userid: String
    var title = String()
    var description = String()
    var status = String()
    var tip = String()
    var materialcost = String()
    var collaborator = String()
}
var applicationSelected = String()
var ProjectDataSet: [ProjectDataset] = []

struct ApplicationDataset {
    var id: String
    var userid: String
    var message = String()
    var firstname = String()
    var lastname = String()
    var imageid = String()
}

var ApplicationDataSet: [ApplicationDataset] = []


class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tablerowlabel: UILabel!
    
    @IBOutlet var applicationconstraint: NSLayoutConstraint!
    
    @IBOutlet var applicationmessage: PrettyViewTextView!
    @IBAction func closeapplicationview(_ sender: Any) {
        applicationconstraint.constant = -10000
    }
    @IBOutlet var statusbar2: PrettyView!
    
    @IBOutlet var statusbar3: PrettyView!
    @IBOutlet var pageheader: UILabel!
    @IBAction func backProjectButton(_ sender: Any) {
       
        subviewviewcontrollername = "ProjectsView"
        wassubview = true
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        self.present(tabViewController, animated: true, completion: nil)
        
    
    }


    @IBOutlet var descriptionlabel: PrettyViewTextView!

    @IBOutlet var tableView: UITableView!
    
    
    @IBAction func acceptApplication(_ sender: Any) {
        
        let json: [String: Any] = ["userid":userID]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=updateapplication&applicationid=\(applicationSelected)&applicationchoice=accept")!
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
            
            if let responseJSON = responseJSON as? String {
//                print(responseJSON)
            }
        }
        
        applicationconstraint.constant = -10000
        task.resume()
        //acceptfunction
    }
    
    @IBAction func declineapplication(_ sender: Any) {
        
      
        
        let json: [String: Any] = ["userid":userID]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=updateapplication&applicationid=\(applicationSelected)&applicationchoice=decline")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsondatatosend
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.fetchapiresults()
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let responseJSON = responseJSON as? String {
//                print(responseJSON)
            }
        }
        
        applicationconstraint.constant = -10000
        task.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProjectDataSet.removeAll()
        fetchapiresults()
        print("this is the statusSelected in projectvc " + statusSelected)
        applicationconstraint.constant = -10000

        // Do any additional setup after loading the view.
    }
    
    
    
    func fetchapiresults(){
        MessageDataSet.removeAll()
        ApplicationDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=project&projectid=\(selectedProject)"
        
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
                   
                    let jsondata = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]
                   
                    
                    if let projectdata = jsondata?["project"] as? NSArray {
                
                    for thing in projectdata as Array{
//                        print(thing)
                        
                        let dataToAdd: ProjectDataset = ProjectDataset(id: thing["id"]! as! String,userid: thing["userid"]! as! String, title: thing["title"]! as! String,description: thing["description"]! as! String, status: thing["status"]! as! String, tip: thing["tip"]! as! String, materialcost: thing["materialcost"]! as! String, collaborator: thing["collaborator"]! as! String)
                        
                        ProjectDataSet.append(dataToAdd)
                        
                    }
                        self.pageheader.text = ProjectDataSet[0].title
                        self.descriptionlabel.text = ProjectDataSet[0].description
                        
                        if ProjectDataSet[0].status == "1" {
                            
                            self.statusbar2.backgroundColor = UIColor.lightGray
                            self.tablerowlabel.text = "Messages"
                            
                        }else{
                            if ProjectDataSet[0].status == "2" {
                                self.statusbar2.backgroundColor = UIColor.darkGray
                                self.statusbar3.backgroundColor = UIColor.darkGray
                                self.tablerowlabel.text = "Complete"
                                
                            }
                        }
                    
                        
                    if ProjectDataSet[0].status == "0" {
                    if let applicationdata = jsondata?["application"] as? NSArray {
                        
                        for thing in applicationdata as Array{
//                            print(thing)
                            
                            let dataToAdd: ApplicationDataset = ApplicationDataset(id: thing["id"]! as! String,userid: thing["userid"]! as! String, message: thing["message"]! as! String, firstname: thing["userfirstname"]! as! String, lastname: thing["userlastname"]! as! String, imageid: thing["userimageid"]! as! String)
                            
                            ApplicationDataSet.append(dataToAdd)
                            
                        }
                    }
                   
                    
                    
                    self.tableView.reloadData()
                    // make sure there is data in the json before setting it or it will crash
                    
                    }else{
                        if ProjectDataSet[0].status == "1" {
                            
                            if let applicationdata = jsondata?["messages"] as? NSArray {
                                
                                for thing in applicationdata as Array{
                              print("getting messages data")
                                    
                                    let dataToAdd: MessageDataset = MessageDataset(id: thing["id"]! as! String,userid: thing["userid"]! as! String, message: thing["message"]! as! String,seen: "0", recipientid: thing["recipientid"]! as! String, username: thing["username"]! as! String)
                                        
                                        MessageDataSet.append(dataToAdd)
                                        
                                    }
//                                  print(MessageDataSet)
                            }
                                    
                            
                                    
                            
                        
                            
                           
                            
                            
                            
//                            print("reloading tableview with messages")
                            self.tableView.reloadData()
                        }else{
                            if ProjectDataSet[0].status == "1"{
                                self.tableView.isHidden = true
                                
                                print("tableview is being hidden")
                                
                                
                                
                                
                            }
                            
                            
                        }
                    
                        
//                    print("doing other things now")
                    }
                    }
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
            }
            
        }
        
        task.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if ProjectDataSet.count == 0 {
            
        }else{
            
        if(ProjectDataSet[0].status == "0"){
        if ApplicationDataSet.count == 0 {
//            print("returning no cells")
            return 1
            
        }else{
//            print("returning data set cells")
            return ApplicationDataSet.count
            
        }
        
        }else{
            if(ProjectDataSet[0].status == "1"){
                return MessageDataSet.count
                
            }else{
            if(ProjectDataSet[0].status == "2"){
                return 0
                
                }
                
                
            }
            
            
            }}
        return 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(ProjectDataSet[0].status == "0"){
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
//        print("creating cells")
        
        if ApplicationDataSet.count == 0 {
            let cell = Bundle.main.loadNibNamed("ProjectsTableViewCell", owner: self, options: nil)?.first as! ProjectsTableViewCell
            cell.projectstitle.text = "You have no Applications"
            return(cell)
            
        }else{
            let cell = Bundle.main.loadNibNamed("ProjectsApplicationTableViewCell", owner: self, options: nil)?.first as! ProjectsApplicationTableViewCell
            
            let wholename = ApplicationDataSet[indexPath.row].firstname + " " + ApplicationDataSet[indexPath.row].lastname
            
            cell.applicationsname.text = wholename
            cell.applicationsimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/\(ApplicationDataSet[indexPath.row].imageid).jpg"))
            
            cell.applicationsimage.layer.borderWidth = 0
            cell.applicationsimage.layer.masksToBounds = false
            cell.applicationsimage.contentMode = .scaleAspectFill
            cell.applicationsimage.layer.cornerRadius = 20
            cell.applicationsimage.clipsToBounds = true
            
             return (cell)
            }
           
            
            }else{
                
                if(ProjectDataSet[0].status == "1"){
                    let cell = Bundle.main.loadNibNamed("MessageLeftTableViewCell", owner: self, options: nil)?.first as! MessageLeftTableViewCell
                    cell.messagecontainer.text = MessageDataSet[indexPath.row].message
                    
                    
                    return (cell)
                }else{
                    
                    if(ProjectDataSet[0].status == "2"){
                    }
                    
            }
            
        }
        let cell = UITableViewCell()
        return (cell) }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ApplicationDataSet.count != 0 {
        applicationconstraint.constant = 0
        applicationmessage.text = ApplicationDataSet[indexPath.row].message
        applicationSelected = ApplicationDataSet[indexPath.row].id
        
    
        }
        
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
