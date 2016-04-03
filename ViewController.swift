//
//  ViewController.swift
//  MapQuest
//
//  Created by steig hallquist on 3/10/16.
//  Copyright © 2016 steig hallquist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    var jsonData:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.showButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.activityView.startAnimating()
        
        let anOperation = NSBlockOperation { () -> Void in
            self.performRequest()
        }
        
        let aQueue = NSOperationQueue()
        aQueue.addOperation(anOperation)
        
        anOperation.waitUntilFinished()
        
        self.activityView.stopAnimating()
        self.showButton.hidden = false
    }
    
    func performRequest(){
        let sURL = "http://www.mapquestapi.com/directions/v2/route?key=\(MAPQUEST_KEY)&from=Lancaster,PA&to=York,PA"
        let nsURL = NSURL(string: sURL);
        
        let sessionTask = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) { (data, response, error) -> Void in
            if error == nil {
                if data != nil { self.jsonData = self.getJSON(data!) }
            } else { //failure
                
            }
        }
        
        sessionTask.resume()
    }
    
    
    func getJSON(results:NSData)->NSDictionary?{
        weak var myData:NSDictionary?
        do {
            myData = try NSJSONSerialization.JSONObjectWithData(results, options: .MutableLeaves) as? NSDictionary
        } catch {
            myData = nil
        }

        return myData
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tVC = segue.destinationViewController as? TableViewController
        
        //tVC?.anArray = self.jsonData!["route"]!["legs"]!!["maneuvers"] as? NSArray
        
        tVC?.source = self.jsonData
    }
    
    
  
}

