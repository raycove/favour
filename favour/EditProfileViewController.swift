//
//  EditProfileViewController.swift
//  favour
//
//  Created by Ray Cove on 05/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

struct EditProfileDataset {
    var firstname: String
    var lastname: String
    var location = String()
    var bio = String()
}

var EditProfileDataSet: [EditProfileDataset] = []

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var firstnametext: UITextField!
    @IBOutlet weak var lastnametext: UITextField!
    @IBOutlet weak var locationtext: UITextField!
    
    @IBAction func done(_ sender: Any) {
        
        subviewviewcontrollername = "ProfileView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
    }
    
    @IBAction func savechanges(_ sender: Any) {
        
        
        let json: [String: Any] = ["id":userID, "firstname":firstnametext.text as! String, "lastname":lastnametext.text as! String, "location":locationtext.text as! String]
        
        let jsondatatosend = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        
        
        
        let url = URL(string: "http://evorbe.com/favour/api.php?request=updateprofiledata")!
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
            if let json = responseJSON as? [String: Any] {
                if json["result"] as! String == "true" {
                print(json)
                
                    
                    
                    print("success")
//                    DispatchQueue.main.async {
//                        if createdFavour != "" {
//                            self.stopanimating()
//
//                            self.performSegue(withIdentifier: "showCreatedFavour", sender: self)
//
//                        }
//                    }
                    
                }else{
                    
                    print("failed")
                    print(json["result"])
                    
                }
            }
        }
        
        
        task.resume()
        
        
    }
    
    
    @IBAction func cancelchangeprofilepic(_ sender: Any) {
        imagecontainerconstraint.constant = -1000
        
    }
    @IBAction func changeprofilepicturebutton(_ sender: Any) {
        
        imagecontainerconstraint.constant = 0
    }
    @IBOutlet weak var imagecontainerconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController()

    @IBAction func uploadImage(_ sender: Any) {
        
       myImageUploadRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        picker.delegate = self
      
        
        
        EditProfileDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=profiledata&id=\(userID)"
        
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
                    
                    
                    
                    
                    
                    let dataToAdd: EditProfileDataset = EditProfileDataset(firstname: jsondata!["firstname"]!,lastname: jsondata!["lastname"]!, location: jsondata!["location"]!, bio: jsondata!["bio"]!)
                    
                    EditProfileDataSet.append(dataToAdd)
                    
                    
                    
                                        self.firstnametext.text = EditProfileDataSet[0].firstname
                                        self.lastnametext.text = EditProfileDataSet[0].lastname
                                        self.locationtext.text = EditProfileDataSet[0].location
                    
                    
                    print(EditProfileDataSet)
                    // make sure there is data in the json before setting it or it will crash
                    
                    
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                
            }
            
        }
        
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SelectImage(_ sender: Any) {
        
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.picker.allowsEditing = false
                    self.picker.sourceType = .photoLibrary
                    self.present(self.picker, animated: true, completion: nil)
                    
                } else {
                    
                }
            })
        }else{
            PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            }
            })
            
        }
        
       
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            imageView.image = pickedImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://evorbe.com/favour/api.php?request=createImage");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "userid"    : userID
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        if(imageView.image == nil)  { print("No Image"); return; }
        
        let imageData = imageView.image!.jpegData(compressionQuality: 1)
        
       
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
//        myActivityIndicator.startAnimating();
        print("uploading")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json)
                
                let imageidnum = json!["Message"]!
                
                userImageId = String(describing: imageidnum)
                
                  DispatchQueue.main.async {
                    self.imagecontainerconstraint.constant = -1000
//                    self.myActivityIndicator.stopAnimating()
                    self.imageView.image = nil;
                    
                    
                    
                    
                }
                
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(userID).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
