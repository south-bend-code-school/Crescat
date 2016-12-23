//
//  SignUpVCViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/22/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVCViewController: UIViewController {

    @IBOutlet weak var studentProfessional: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var companyMajorTextField: UITextField!
    @IBOutlet weak var positionYearTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        

        
    }

    @IBAction func studentProfessionalAction(_ sender: Any) {

        if studentProfessional.selectedSegmentIndex == 0 {
            print("value is student");
            companyMajorTextField.placeholder = "Major"
            positionYearTextField.placeholder = "Year"
        }
        if studentProfessional.selectedSegmentIndex == 1 {
            print("value is professional");
            companyMajorTextField.placeholder = "Company"
            positionYearTextField.placeholder = "Position"
        }
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                if error == nil
                {
                    // successfully logged in
                    //self.userLabel.text = "signed in, checking for email verification..."
                    
                    // check for email verification
                    if let user = FIRAuth.auth()?.currentUser {
                        if !user.isEmailVerified
                        {
                            NSLog("email is NOT verified");
                            let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.emailTextField.text).", preferredStyle: .alert)
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
                            print("signed in woo!!!")
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            
                            self.performSegue(withIdentifier: "userHomeSegue", sender: self)
                            
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

    @IBAction func signUpAction(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {

            
            // create account
            FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                if error == nil
                {
                    // successfully created user
                    self.statusLabel.text = "waiting for email verification"
                    
                    NSLog("sending verification email")
                    user?.sendEmailVerification(completion: nil)
                    try! FIRAuth.auth()?.signOut()
                    
                    self.statusLabel.alpha = 1.0
                    self.loginButton.alpha = 1.0
                    self.signUpButton.alpha = 0.0
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
