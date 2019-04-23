//
//  ViewController.swift
//  DatabaseExample
//
//  Created by media on 2019-04-22.
//

import Foundation
import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func onClick(_ sender: UIButton) {
        if emailText.text != "" && passwordText.text != ""{
            if segmentControl.selectedSegmentIndex == 0{//Login
                
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                    
                    if user != nil
                    {
                        self.performSegue(withIdentifier: "Transition", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                        
                    }
                }
            }
            else
            { //Signup
                
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                    
                    if user != nil
                    {
                        self.performSegue(withIdentifier: "Transition", sender: self)
                    }
                    else
                    {
                        if let myError = error?.localizedDescription
                        {
                            print(myError)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    }
                }
            }
        }
    }
    
    
    
    
}
