//
//  TabViewController.swift
//  favour
//
//  Created by Ray Cove on 16/01/2018.
//  Copyright © 2018 Ray Cove. All rights reserved.
//

import UIKit

var homeView: UIViewController!
var nearbyView: UIViewController!
var messagesView: UIViewController!
var projectsView: UIViewController!
var searchView: UIViewController!
var tabView: UIViewController!




var subviewviewcontroller: UIViewController!

var subviewviewcontrollername = String()
var wassubview = false
var viewControllers: [UIViewController]!

var selectedIndex: Int = 0

class TabViewController: UIViewController {


    @IBOutlet var navButtons: [UIButton]!
    
    @IBOutlet var thecontentView: UIView!
    
    

//    func showsubviewsubs(){
//
//        let previousVC = viewControllers[selectedIndex]
//
//        previousVC.willMove(toParentViewController: nil)
//        previousVC.view.removeFromSuperview()
//        previousVC.removeFromParentViewController()
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        subviewviewcontroller = storyboard.instantiateViewController(withIdentifier:"HomeView")
//
//        let vc = subviewviewcontroller
//
////        self.addChildViewController(vc!)
////        vc?.view.frame = thecontentView.bounds
////        thecontentView.addSubview((vc?.view)!)
////
////        vc?.didMove(toParentViewController: self)
//
//    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
  
            let previousIndex = selectedIndex
//            print(previousIndex)
        selectedIndex = (sender as AnyObject).tag
//            print(selectedIndex)
        
     navButtons[previousIndex].isSelected = false

        let previousVC = viewControllers[previousIndex]

        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        

        sender.isSelected = true

        let vc = viewControllers[selectedIndex]
        addChild(vc)

        vc.view.frame = thecontentView.bounds
        thecontentView.addSubview(vc.view)

        vc.didMove(toParent: self)
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeView = storyboard.instantiateViewController(withIdentifier: "HomeView")
        nearbyView = storyboard.instantiateViewController(withIdentifier: "NearbyView")
        searchView = storyboard.instantiateViewController(withIdentifier: "SearchView")
        messagesView = storyboard.instantiateViewController(withIdentifier: "MessagesView")
        projectsView = storyboard.instantiateViewController(withIdentifier: "ProjectsView")
       viewControllers = [homeView,searchView,nearbyView,messagesView,projectsView]
        if(wassubview == false){
  didPressTab(navButtons[selectedIndex])
        }else{
            
            let previousIndex = selectedIndex
//            print(previousIndex)
//            print(selectedIndex)
            
            navButtons[previousIndex].isSelected = false
            
            let previousVC = viewControllers[previousIndex]
            
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            subviewviewcontroller = storyboard.instantiateViewController(withIdentifier: subviewviewcontrollername)
            
            addChild(subviewviewcontroller)
            
            subviewviewcontroller.view.frame = thecontentView.bounds
            thecontentView.addSubview(subviewviewcontroller.view)
            
            subviewviewcontroller.didMove(toParent: self)
            
            wassubview = false
            
        }
        
        
        
        
        
        
        
//        navButtons[selectedIndex].isSelected = true
       

        // Do any additional setup after loading the view.
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
