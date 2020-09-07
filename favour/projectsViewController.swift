//
//  projectsViewController.swift
//  favour
//
//  Created by Ray Cove on 02/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

let raysgrey = UIColor( red: CGFloat(243/255.0), green: CGFloat(243/255.0), blue: CGFloat(243/255.0), alpha: CGFloat(1.0) )
let raysblue = UIColor( red: CGFloat(26/255.0), green: CGFloat(109/255.0), blue: CGFloat(222/255.0), alpha: CGFloat(1.0) )

var selectedProject = String()
var statusSelected = String()
var statusSelectedNum = Int()
struct ProjectsDataset {
    var id: String
    var userid: String
    var title = String()
    var description = String()
}

var statusNames = ["MY FAVOURS","COLLABORATIONS","APPLICATIONS"]


var ProjectsDataSet: [ProjectsDataset] = []

class projectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    

    @IBOutlet var headerlabel: UILabel!
    
    @IBOutlet var projectViewButtons: [UIView]!
    
    
    @IBOutlet var buttonimages: [UIImageView]!
    
   
    
    // or for Swift 3
    @objc func someAction(_ sender:UITapGestureRecognizer){
        print("setStatus Function Occuring")
        print(String(describing: sender.view!.tag))
        if sender.view!.tag == statusSelectedNum {
            print("same tab selected")
            
        }else{
        projectViewButtons[statusSelectedNum].backgroundColor = raysgrey
            buttonimages[statusSelectedNum].image = buttonimages[statusSelectedNum].image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            buttonimages[statusSelectedNum].tintColor = nil // your color
        statusSelected = String(describing: sender.view!.tag)
        statusSelectedNum = sender.view!.tag
        projectViewButtons[statusSelectedNum].backgroundColor = raysblue
            buttonimages[statusSelectedNum].image = buttonimages[statusSelectedNum].image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            buttonimages[statusSelectedNum].tintColor = UIColor.white // your color
        headerlabel.text = statusNames[statusSelectedNum]
//        if statusSelected == "1" { statusSelectedNum = 1}else{ if statusSelected == "2"{ statusSelectedNum = 2}else{ statusSelectedNum = 3}}
        print("this is the project status after someAction" + statusSelected)
        fetchapiresults()
        }
    }


    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("running view did load")
        let gesture1 = UITapGestureRecognizer(target: self, action:#selector (self.someAction (_:)))
        let gesture2 = UITapGestureRecognizer(target: self, action:#selector (self.someAction (_:)))
        let gesture3 = UITapGestureRecognizer(target: self, action:#selector (self.someAction (_:)))
        projectViewButtons[0].addGestureRecognizer(gesture1)
        projectViewButtons[1].addGestureRecognizer(gesture2)
        projectViewButtons[2].addGestureRecognizer(gesture3)
        projectViewButtons[0].backgroundColor = raysgrey
        projectViewButtons[1].backgroundColor = raysgrey
        projectViewButtons[2].backgroundColor = raysgrey
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
     
            print("view appearing")
            if statusSelected == "" {
                print("setting to 0")
                statusSelected = "0"
                statusSelectedNum = 0
                projectViewButtons[statusSelectedNum].backgroundColor = raysblue
                buttonimages[statusSelectedNum].image = buttonimages[statusSelectedNum].image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                buttonimages[statusSelectedNum].tintColor = UIColor.white // your color
                fetchapiresults()
                
                print ("project status NOT set")
                headerlabel.text = statusNames[statusSelectedNum]
            }else{
                headerlabel.text = statusNames[statusSelectedNum]
                projectViewButtons[statusSelectedNum].backgroundColor = raysblue
                buttonimages[statusSelectedNum].image = buttonimages[statusSelectedNum].image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                buttonimages[statusSelectedNum].tintColor = UIColor.white // your color
                fetchapiresults()
                print("project status IS set")
                
            }
            
        }
       
        
        
      

        // Do any additional setup after loading the view.
 
    func viewDidDisappear() {
        print("view did disapear")
        
        ProjectsDataSet.removeAll()
        
        
    }
    
    func fetchapiresults(){
        ProjectsDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=projects&userid=\(userID)&status=\(statusSelected)"
        
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
//                        print(thing)
                        
                        let dataToAdd: ProjectsDataset = ProjectsDataset(id: thing["id"]!,userid: thing["userid"]!, title: thing["title"]!,description: thing["description"]!)
                        
                        ProjectsDataSet.append(dataToAdd)
                        
                    }
                    
//                    print(ProjectsDataSet)
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
        if ProjectsDataSet.count == 0 {
            return 1
        }else{
            return ProjectsDataSet.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        
//        tableView.estimatedRowHeight = 60
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        if ProjectsDataSet.count == 0 {
            let cell = Bundle.main.loadNibNamed("ProjectsTableViewCell", owner: self, options: nil)?.first as! ProjectsTableViewCell
            cell.projectstitle.text = "You have no Projects"
            cell.tableviewcellbackground.backgroundColor = raysgrey
            return(cell)
            
        }else{
            let cell = Bundle.main.loadNibNamed("ProjectsTableViewCell", owner: self, options: nil)?.first as! ProjectsTableViewCell
            cell.tableviewcellbackground.backgroundColor = raysgrey
            cell.projectstitle.text = ProjectsDataSet[indexPath.row].title
            
            return(cell)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
       if ProjectsDataSet.count == 0 {
        return nil
       }else{
        return indexPath
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            selectedProject = ProjectsDataSet[indexPath.row].id
            
        
        subviewviewcontrollername = "ProjectView"
        wassubview = true
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        self.present(tabViewController, animated: true, completion: nil)
        
        
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
