//
//  MessageViewController.swift
//  favour
//
//  Created by Ray Cove on 01/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

struct MessageDataset {
    var id: String
    var userid: String
    var message = String()
    var seen = String()
    var recipientid = String()
    var username = String()
}

var MessageDataSet: [MessageDataset] = []


class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: MessageDataSet.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

  

    @IBOutlet weak var messageprofileimage: UIButton!
    
    @IBAction func messagetoprofile(_ sender: Any) {
        if MessageDataSet[0].userid == userID {
        userprofileid = MessageDataSet[0].recipientid
        }else{
        userprofileid = MessageDataSet[0].userid
        }
    
        subviewviewcontrollername = "ProfileView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var messageusername: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var messagetext: UITextView!

    
    @IBAction func sendmessage(_ sender: Any) {
        
        let json: [String: Any] = ["userid":userID,"recipientid":selectedMessage, "message":messagetext.text]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=createmessage")!
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
                print(responseJSON)
            }
        }
        
        messagetext.text = ""
        task.resume()
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        fetchapiresults()
        automaticallyAdjustsScrollViewInsets = false
        
    }

    
    
      func fetchapiresults(){
        MessageDataSet.removeAll()
            let APIURL = "http://evorbe.com/favour/api.php?request=message&userid=\(userID)&recipientid=\(selectedMessage)"
            
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
                            
                            let dataToAdd: MessageDataset = MessageDataset(id: thing["id"]!,userid: thing["userid"]!, message: thing["message"]!,seen: thing["seen"]!, recipientid: thing["recipientid"]!, username: thing["username"]!)
                            
                            MessageDataSet.append(dataToAdd)
                            
                        }
                        
                        print(MessageDataSet)
                        
                      
                        
                        self.tableView.reloadData()
                        self.scrollToBottom()
                        
                        self.messageusername.text = selectedMessageUsername
                        
                        self.messageprofileimage.layer.borderWidth = 0
                        self.messageprofileimage.layer.masksToBounds = false
                        self.messageprofileimage.layer.cornerRadius = 20
                        self.messageprofileimage.clipsToBounds = true
                        self.messageprofileimage.setBackgroundImage(selectedMessageImage, for: .normal)
                        
                        ///////////////// code for checking if a struc is out of range //////////////
                        
//                        var i = 0
//                        var set = false
//                        while set == false {
//                            let intendedIndex: Int = i
//
//                            if (intendedIndex >= 0 && MessageDataSet.count > intendedIndex) {
//                                // This line will not throw index out of range:
//
//                            if MessageDataSet[i].username != userName {
//                        self.messageusername.text = selectedMessageUsername
//                                set = true
//                            }
//                                print("not this one")
//                        i += 1
//                            }else{
//                        print("index out of range")
//
//                              return
//                            }
//                        }
                        
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
        if MessageDataSet.count == 0 {
            return 1
        }else{
            return MessageDataSet.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        
        if MessageDataSet.count == 0 {
            let cell = Bundle.main.loadNibNamed("MessageLeftTableViewCell", owner: self, options: nil)?.first as! MessageLeftTableViewCell
            cell.messagecontainer.text = "You have no messages"
            return(cell)
            
        }else{
            if MessageDataSet[indexPath.row].userid == userID {
                let cell = Bundle.main.loadNibNamed("MessageRightTableViewCell", owner: self, options: nil)?.first as! MessageRightTableViewCell
                cell.messagecontainer.text = MessageDataSet[indexPath.row].message
                 return(cell)
            }else{
            let cell = Bundle.main.loadNibNamed("MessageLeftTableViewCell", owner: self, options: nil)?.first as! MessageLeftTableViewCell
            cell.messagecontainer.text = MessageDataSet[indexPath.row].message
                 return(cell)
            }
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        // Do any additional setup after loading the view.
}

