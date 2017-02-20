//
//  SignUpVCViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/22/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpVCViewController: UIViewController, UITextFieldDelegate {

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
        
        makePretty()
    }
    
    func makePretty() {
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.mobileTextField.delegate = self
        self.schoolTextField.delegate = self
        self.companyMajorTextField.delegate = self
        self.positionYearTextField.delegate = self
        self.industryTextField.delegate = self
        self.locationTextField.delegate = self

        self.addDoneButtonOnKeyboard()
        
        // nav bar colors
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //self.navigationController?.navigationBar.topItem?.title = "Create Account"

    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.mobileTextField.inputAccessoryView = doneToolbar
        self.positionYearTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.mobileTextField.resignFirstResponder()
        self.positionYearTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
        if self.emailTextField.text == "" || self.passwordTextField.text == "" || self.nameTextField.text == "" || self.mobileTextField.text == "" || self.companyMajorTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter all of the required fields", preferredStyle: .alert)
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

                                let name = self.nameTextField.text
                                let email = self.emailTextField.text
                                let password = self.passwordTextField.text
                                let mobile = self.mobileTextField.text
                                let companyMajor = self.companyMajorTextField.text
                                let positionYear = self.positionYearTextField.text
                                let school = self.schoolTextField.text
                                let industry = self.industryTextField.text
                                let location = self.locationTextField.text


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
                            //self.emailTextField.text = ""
                            //self.passwordTextField.text = ""
                            
                            
                            
                            // update database with this newly created user
                            var ref: FIRDatabaseReference!
                            ref = FIRDatabase.database().reference()
                            
                            if self.studentProfessional.selectedSegmentIndex == 0 {
                                print("adding new student info to database");
                                
                                let studentUserInfo = [
                                    "name": name,
                                    "email": email,
                                    "password": password,
                                    "mobile": mobile,
                                    "major": companyMajor,
                                    "year": positionYear ?? "",
                                    "school": school ?? "",
                                    "industry": industry ?? "",
                                    "location": location ?? "",
                                    "isStudent": true,
                                    "isProfessional":false
                                ] as [String : Any]
                                ref.child("users").child(user.uid).setValue(["userInfo": studentUserInfo])
                            }
                            else if self.studentProfessional.selectedSegmentIndex == 1 {
                                print("adding new professional info to database");
                                
                           let professionalUserInfo = [
                                    "name": name,
                                    "email": email,
                                    "password": password,
                                    "mobile": mobile,
                                    "company": companyMajor,
                                    "position": positionYear ?? "",
                                    "school": school ?? "",
                                    "industry": industry ?? "",
                                    "location": location ?? "",
                                    "isStudent": false,
                                    "isProfessional":true
                                ] as [String : Any]
                                ref.child("users").child(user.uid).setValue(["userInfo": professionalUserInfo])
                            }
                            else {
                                print("ERROR! wasn't student or professional?")
                            }
                            
                            
                            // now go to user's home page
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

    @IBAction func signUp(_ sender: Any) {
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
                    self.statusLabel.text = "please verify email"
                    
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

}
