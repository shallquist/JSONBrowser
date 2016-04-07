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
    @IBOutlet weak var urlField: UITextField!

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
        
        //start animating activity view
        
        
        self.showButton.hidden = false
    }
    
    func performRequest(){
        let sURL = self.urlField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if !sURL!.isEmpty {
            let nsURL = NSURL(string: sURL!);
            
            // start session to retrieve data
            let sessionTask = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) { (data, response, error) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    if error == nil {
                        if data != nil {
                            self.jsonData = self.extractJSON(data!)
                            self.performSegueWithIdentifier("ShowDetail", sender: self)
                        }  //get JSON Data from response
                    } else { //failure
                        print(error)
                    }
                    
                    self.showButton.enabled = true
                })
            }
            
            self.showButton.enabled = false
            sessionTask.resume()
        }
    }
    
    
    func extractJSON(results:NSData)->NSDictionary?{
        weak var myData:NSDictionary?
        do {
            myData = try NSJSONSerialization.JSONObjectWithData(results, options: .MutableLeaves) as? NSDictionary
        } catch {
            myData = nil
        }

        return myData
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tVC = segue.destinationViewController as? MainTableViewController
        
        //assign JSON Data to Table View controller
        tVC?.source = self.jsonData
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !(self.jsonData == nil)
    }
    
    
    @IBAction func getJSON(sender: UIButton) {
        //create an operation to run url request
        self.performRequest()
    }
}

