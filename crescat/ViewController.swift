//
//  ViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/10/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate {

    //@IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    //@IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var name:String!
    var position:String!
    var company:String!
    var location:String!
    var industry:String!
    var school:String!
    
    //var professionalArray: [[String:AnyObject]] = [] // has all the prof data
    var questionArray: [[String:AnyObject]] = []
    //var followeesArray: [String] = []

    
    //var uid:String! // for segue if is professional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        /*
        // check if there is a user logged in
        if let user = FIRAuth.auth()?.currentUser {
            //self.logoutButton.alpha = 1.0
            //self.userLabel.text = user.email
        }
        else {
            //self.logoutButton.alpha = 0.0
            //self.userLabel.text = ""
        }
        */
        makePretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.view.backgroundColor = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: 1)
    }
    
    func makePretty() {
        loginButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        forgotPasswordButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createAccountAction(_ sender: Any) {
    }

    /*
    @IBAction func logoutAction(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.userLabel.text = ""
        //self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    }
 */
    
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
                            
                            self.startActivityIndicator()
                            
                            // lets just get these overwith here
                            self.getProfessionalsList()
                            self.getQuestionsAndAnswers()
                            
                            // check to see if is prof or student
                            let uid = FIRAuth.auth()?.currentUser?.uid
                            let userPath = "users/" + uid!
                            let usersRef = FIRDatabase.database().reference(withPath: userPath)
                            var isStudent:Bool!
                            
                            usersRef.observe(.childAdded, with: { snapshot in
                                print(snapshot.value)
                                let json = snapshot.value as! [String:AnyObject]
                                isStudent = json["isStudent"] as! Bool
                                print("isStudent:")
                                print("isStudent")
                                
                                if (isStudent == true) {
                                    print("is student")
                                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                                }
                                else {
                                    print("is professor")
                                    sleep(2)
                                    
                                    self.performSegue(withIdentifier: "loginToProf", sender: self)
                                }
                            })

                            
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
    
    func startActivityIndicator() {
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    func stopActivityIndicator() {
        activityView.stopAnimating()
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
    
    
    
    
    // stuff for prof profile view controller segue
    
    func getQuestionsAndAnswers() {
        questionArray = [] // reset question array
        
        let questionsRef = FIRDatabase.database().reference(withPath: "questions").queryOrdered(byChild: "date")
        
        questionsRef.observe(.childAdded, with: { snapshot in
            
            let json = snapshot.value as! [String:AnyObject]
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            // check if following this prof, if so then put question in array to be displayed
            if (json["uid"] as! String? == uid) {
                
                var questionData: [String:String] = [:]
                
                let question = json["question"]
                let answer = json["answer"]
                let uid = json["uid"]
                let profName = json["profName"]
                let date = json["date"]
                
                questionData["answer"] = answer as! String?
                questionData["question"] = question as! String?
                questionData["uid"] = uid as! String?
                questionData["profName"] = profName as! String?
                questionData["date"] = date as! String?
                
                self.questionArray.append(questionData as [String : AnyObject])
            }
        })
    }
    
    func getProfessionalsList() {
        // we know this is a prof signing in, so we can just look up their info and go straight to their profile
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let path = "users/" + uid!
        let usersRef = FIRDatabase.database().reference(withPath: path)
        
        usersRef.observe(.childAdded, with: { snapshot in
            
            let json = snapshot.value as! [String:AnyObject]
            
            // storing UID under userInfo also, makes following easier
            print(snapshot.key)
            let userID = snapshot.key
            
            print("this user here idk:")
            print(snapshot.value)
            
            let userInfo = snapshot.value as! [String:AnyObject]
                       self.name = userInfo["name"] as! String!
            self.company = userInfo["company"] as! String!
            self.location = userInfo["location"] as! String!
            self.position = userInfo["position"] as! String!
            self.industry = userInfo["industry"] as! String!
            self.school = userInfo["school"] as! String!


        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func returnPressed(sender: UITextField) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToProf") {
            let yourNextViewController = (segue.destination as! ProfileViewController)
            
            //let profUID = question["uid"] as! String
            let uid = FIRAuth.auth()?.currentUser?.uid
            let profUID = uid
            
            yourNextViewController.uid = profUID
            yourNextViewController.name = name
            yourNextViewController.location = location
            yourNextViewController.position = position
            yourNextViewController.company = company
            yourNextViewController.industry = industry
            yourNextViewController.school = school
            //yourNextViewController.showBackButton = false
            
            yourNextViewController.questionArray = self.questionArray
            
            stopActivityIndicator()
        }

    }
    
    
}

