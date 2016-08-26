//
//  LogsTableViewController.swift
//  Aeoluz
//
//  Created by Kaira Villanueva on 8/18/16.
//  Copyright © 2016 Kaira Villanueva. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LogsTableViewController: UITableViewController {
    
    var dbRef: FIRDatabaseReference!
    var logs = [Log]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("log-items")
        startObservingDB()

    }

    // MARK: - Table view data source

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            
            if let user = user {
                print("Welcomme \(user.email)")
                self.startObservingDB()
            } else {
                print("You need to login first")

            }
        })
    }

    
    func startObservingDB () {
        dbRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
            var newLogs = [Log]()
            
            for log in snapshot.children {
                let logObject = Log(snapshot: log as! FIRDataSnapshot)
                newLogs.append(logObject)
            }
            
            self.logs = newLogs
            self.tableView.reloadData()
            
            
        }) { (error:NSError) in
            print(error.description)
        }
    }

    @IBAction func loginAndSignUp(sender: AnyObject) {
        let userAlert = UIAlertController(title: "Login",
                                        message: "Enter Email and Password",
                                        preferredStyle: .Alert)
        
        userAlert.addTextFieldWithConfigurationHandler { (textfield:UITextField) in
            textfield.placeholder = "email"
        }
        
        userAlert.addTextFieldWithConfigurationHandler{(textfield:UITextField) in
            textfield.secureTextEntry = true
            textfield.placeholder = "password"
        }
        
        userAlert.addAction(UIAlertAction(title: "Sign in",
            style: .Default, handler: { (action: UIAlertAction) in
                let emailTextField = userAlert.textFields!.first!
                let passwordTextField = userAlert.textFields!.last!
                
                FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error: NSError?) in
                    if error != nil {
                        print(error?.description)
                    }
                })
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign up",
            style: .Default, handler: { (action: UIAlertAction) in
                let emailTextField = userAlert.textFields!.first!
                let passwordTextField = userAlert.textFields!.last!
                
                FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                    if error != nil {
                        print(error?.description)
                    }
                })
                
        }))
        
        self.presentViewController(userAlert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addLog(sender: AnyObject) {
        let logAlert = UIAlertController(title: "New Log", message: "Enter Your Log", preferredStyle: .Alert)
        logAlert.addTextFieldWithConfigurationHandler { (textField:UITextField) in
            textField.placeholder = "You Log"
        }
        
        logAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action: UIAlertAction) in
            if let logContent = logAlert.textFields?.first?.text {
                let log = Log(content: logContent, addedByUser: "Demo")
                let logRef = self.dbRef.child(logContent.lowercaseString)
                
                logRef.setValue(log.toAnyObject())
            }
            
        }))
        
        self.presentViewController(logAlert, animated: true, completion: nil)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logs.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let log = logs[indexPath.row]
        
        cell.textLabel?.text = log.content
        cell.detailTextLabel?.text = log.addedByUser


        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let log = logs[indexPath.row]
            log.itemRef?.removeValue()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
