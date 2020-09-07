//
//  MessagesViewController.swift
//  favour
//
//  Created by Ray Cove on 01/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit
var selectedMessage = String()
var selectedMessageUsername = String()
var selectedMessageImage = UIImage()
struct MessagesDataset {
    var id: String
    var userid: String
    var message = String()
    var seen = String()
    var recipientid = String()
    var username = String()
    var userimageid = String()
}

var MessagesDataSet: [MessagesDataset] = []

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    func fetchapiresults(){
        
        FavoursDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=messages&userid=\(userID)"
        
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
                        
                        let dataToAdd: MessagesDataset = MessagesDataset(id: thing["id"]!,userid: thing["userid"]!, message: thing["message"]!,seen: thing["seen"]!, recipientid: thing["recipientid"]!, username: thing["username"]!, userimageid: thing["userimageid"]!)
                        
                        MessagesDataSet.append(dataToAdd)
                        
                    }
                    
                    print(MessagesDataSet)
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
        if MessagesDataSet.count == 0 {
            return 1
        }else{
            return MessagesDataSet.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        
        if MessagesDataSet.count == 0 {
            let cell = Bundle.main.loadNibNamed("MessagesTableViewCell", owner: self, options: nil)?.first as! MessagesTableViewCell
            cell.messageslabel.text = "You have no messages"
            return(cell)
            
        }else{
            let cell = Bundle.main.loadNibNamed("MessagesTableViewCell", owner: self, options: nil)?.first as! MessagesTableViewCell
            cell.messageslabel.text = MessagesDataSet[indexPath.row].username
            if MessagesDataSet[indexPath.row].seen == "0" {
            cell.messagesseen.text =  ""
            }else{
            cell.messagesseen.text =  MessagesDataSet[indexPath.row].seen
            }
            
            cell.messagesimage.layer.borderWidth = 0
            cell.messagesimage.layer.masksToBounds = false
            cell.messagesimage.contentMode = .scaleAspectFill
            cell.messagesimage.layer.cornerRadius = 20
            cell.messagesimage.clipsToBounds = true
            
           
            
            
            
            cell.messagesimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/" + MessagesDataSet[indexPath.row].userimageid + ".jpg"))
            
            
                        
                        
                        
        return cell
        }
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if MessagesDataSet[indexPath.row].userid == userID {
        selectedMessage = MessagesDataSet[indexPath.row].recipientid
            let cell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
            selectedMessageImage = cell.messagesimage.image!
            selectedMessageUsername = cell.messageslabel.text!
        }else{
        selectedMessage = MessagesDataSet[indexPath.row].userid
        
        let cell = tableView.cellForRow(at: indexPath) as! MessagesTableViewCell
        selectedMessageUsername = cell.messageslabel.text!
        selectedMessageImage = cell.messagesimage.image!
        
        }
        
        subviewviewcontrollername = "MessageView"
        wassubview = true
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        self.present(tabViewController, animated: true, completion: nil)
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewappeared messages")
        MessagesDataSet.removeAll()
        fetchapiresults()
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
