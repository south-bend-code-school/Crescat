//
//  ViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/10/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let user = FIRAuth.auth()?.currentUser {
            self.logoutButton.alpha = 1.0
            self.userLabel.text = user.email
        }
        else {
            self.logoutButton.alpha = 0.0
            self.userLabel.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            // create account
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil
                {
                    // successfully created user
                    self.userLabel.text = "waiting for email verification"
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    
                    NSLog("sending verification email")
                    user?.sendEmailVerification(completion: nil)
                    try! FIRAuth.auth()?.signOut()
                }
                else
                {
                    // failed to create user
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func logoutAction(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.userLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil
                {
                    // successfully logged in
                    //self.userLabel.text = "signed in, checking for email verification..."
                    
                    // check for email verification
                    if let user = FIRAuth.auth()?.currentUser {
                        if !user.isEmailVerified
                        {
                            NSLog("email is NOT verified");
                            let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.emailField.text).", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                                (_) in
                                user.sendEmailVerification(completion: nil)
                            }
                            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alertVC.addAction(alertActionOkay)
                            alertVC.addAction(alertActionCancel)
                            self.present(alertVC, animated: true, completion: nil)
                            
                            // sign them out because email not verified
                            try! FIRAuth.auth()?.signOut()
                        }
                        else
                        {
                            NSLog("Email verified. Signing in...")
                            self.logoutButton.alpha = 1.0
                            self.userLabel.text = user.email
                            self.emailField.text = ""
                            self.passwordField.text = ""

                        }
                    }
                    
                    
                }
                else
                {
                    // failed to login
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }

            })
 

        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {

        if self.emailField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailField.text!) { error in
                if let error = error {
                    // An error happened.
                    let alertVC = UIAlertController(title: "Oops!", message: "Failed to send reset password link to \(self.emailField.text)", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                    (_) in
                    }
                
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)
                }
                else
                {
                    // Password reset email sent.
                    let alertVC = UIAlertController(title: "Reset Password Email Sent", message: "Reset password link sent to \(self.emailField.text).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                    }
                
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)

                }
            }
        }
    }
}

