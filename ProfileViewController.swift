//
//  ProfileViewController.swift
//  favour
//
//  Created by Ray Cove on 04/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

var name = ""
var location = ""
var bio = ""
var profileimageid = ""

let urlstring2 = "http://evorbe.com/images/responsivepic.jpg"
var userprofileid = String()

struct ProfileDataset {
    var firstname: String
    var lastname: String
    var location = String()
    var bio = String()
    var imageid = String()
}

var ProfileDataSet: [ProfileDataset] = []


class ProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoutbutton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var chatbutton: UIButton!
    
    
    @IBAction func chatbuttonaction(_ sender: Any) {
        
       selectedMessage = userprofileid
        subviewviewcontrollername = "MessageView"
        wassubview = true
        let tabViewController = storyboard?.instantiateViewController(withIdentifier: "TabView") as! TabViewController
        tabViewController.modalPresentationStyle = .overCurrentContext
        present(tabViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userprofileid != userID {
            editbutton.isHidden = true
            logoutbutton.isHidden = true
            chatbutton.isHidden = false
        }else{
            editbutton.isHidden = false
            logoutbutton.isHidden = false
            chatbutton.isHidden = true
        }
        
        self.collectionView.register(UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header");
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier:"cell")
       
        
      
        
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 20,left: 0,bottom: 10,right: 0)
        layout.itemSize = CGSize(width:itemSize, height:itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        collectionView.collectionViewLayout = layout
        
        ProfileDataSet.removeAll()
        let APIURL = "http://evorbe.com/favour/api.php?request=profiledata&id=\(userprofileid)"
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
                    
                    
                    
                    
                    
                    let dataToAdd: ProfileDataset = ProfileDataset(firstname: jsondata!["firstname"]!,lastname: jsondata!["lastname"]!, location: jsondata!["location"]!, bio: jsondata!["bio"]!, imageid: jsondata!["imageid"]!)
                    
                   ProfileDataSet.append(dataToAdd)
                    
                    
                    
                    name = "\(ProfileDataSet[0].firstname) \(ProfileDataSet[0].lastname)"
                    location = "\(ProfileDataSet[0].location)"
                    bio = "\(ProfileDataSet[0].bio)"
                    profileimageid = "\(ProfileDataSet[0].imageid)"
                    
                    
                    print(EditProfileDataSet)
                    // make sure there is data in the json before setting it or it will crash
                    
                    self.collectionView.reloadData()
                    
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
                
                
            }
            
        }
        
        task.resume()
        

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
   
func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        if let url = URL(string: urlstring2) {
      cell.cellimage.sd_setImage(with: URL(string: urlstring2))
                   
                    
                }
        
        
        
         cell.backgroundColor = UIColor.black
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    


    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
let headerView = Bundle.main.loadNibNamed("ProfileHeaderCollectionReusableView", owner: self, options: nil)?.first as! ProfileHeaderCollectionReusableView
        
        let isIndexValid = ProfileDataSet.indices.contains(0)
        var theheaderViewSize = CGSize()
        if isIndexValid == true {
            print("it is being set")
        
        headerView.profilebio.text = ProfileDataSet[0].bio
     
            let label = headerView.profilebio
            label?.text = ProfileDataSet[0].bio
            label?.contentMode = .scaleToFill
            
            let fixedWidth = label?.frame.size.width
            label?.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
            let newSize = label?.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = label?.frame
            newFrame?.size = CGSize(width: max((newSize?.width)!, fixedWidth!), height: ((newSize?.height)! + 14))
            label?.frame = newFrame!
            
            
            // Set some extra pixels for height due to the margins of the header section.
            //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 16 worked for me as I have 8px for top and bottom constraints.
            theheaderViewSize = CGSize(width: collectionView.frame.width, height: (label?.frame.height)! + headerView.topview.bounds.height + 20)
            
        }else{
            
        theheaderViewSize = CGSize(width: collectionView.bounds.width,height: 280 )
        }
      
       return theheaderViewSize
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionView.elementKindSectionHeader:
            //3
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "Header",for: indexPath) as! ProfileHeaderCollectionReusableView
            
            headerView.profilename.text = name
            headerView.profilebio.text = bio
            headerView.profilelocation.text = location

                            headerView.profileimage.sd_setImage(with: URL(string: "http://evorbe.com/favour/uploads/\(profileimageid).jpg"))



            headerView.profileimage.layer.borderWidth = 0
            headerView.profileimage.layer.masksToBounds = false

            headerView.profileimage.layer.cornerRadius = headerView.profileimage.frame.height/2
            headerView.profileimage.clipsToBounds = true
            
            return headerView
        default: 
            //4
            assert(false, "Unexpected element kind")
        }
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

