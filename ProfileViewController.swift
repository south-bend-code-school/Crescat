//
//  ViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/27/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var uid:String!
    var name:String!
    var position:String!
    var company:String!
    var location:String!
    var industry:String!
    var school:String!
    
    var questionArray: [[String:AnyObject]] = []
    
    var oldColor:UIColor!
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var professionalName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cellOfFun"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        professionalName.text = name
        titleLabel.text = position + " at " + company
        locationLabel.text = location
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // see if cells should have editable answer
        let user = FIRAuth.auth()?.currentUser
        let currentUser = user?.uid
        if (self.uid == currentUser) {
            // this is the user's own profile
            
            // make logout button
            let logButton : UIBarButtonItem = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.logout(_:)))
            self.navigationItem.rightBarButtonItem = logButton
            
            navigationItem.hidesBackButton = true
        }
        
        
        if (self.questionArray.count > 0) {
            print("got full questions array")
            filterQuestions()
        }
        else {
            print("got empty questions array")
            getQuestionsAndAnswers()
        }
        
        makeProPicPretty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        oldColor = self.navigationController!.view.backgroundColor
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func makeProPicPretty() {
        profilePic.layer.borderWidth = 3
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.image = UIImage(named: "obama.png") // probs un-hard-code this sometime
    }
    
    

    
    func filterQuestions() {
        var thisProfsQuestions: [[String:AnyObject]] = []
        var i = 0
        while i < self.questionArray.count {
            let q = self.questionArray[i]
            if (q["uid"] as! String == uid) {
                thisProfsQuestions.append(q)
            }
            i += 1
        }
        self.questionArray = thisProfsQuestions
        tableView.reloadData()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionArray.count
        //return self.questions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ProfileTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProfileTableViewCell
        
        let thisQuestion = self.questionArray[indexPath.row]
        //let name = thisQuestion["profName"] as! String?
        let question = thisQuestion["question"] as! String?
        let answer = thisQuestion["answer"] as! String?
        
        cell.questionLabel.text = "Q: " + question!
        cell.answerTextView.text = "A: " + answer!
        cell.dateLabel.text = thisQuestion["date"] as! String?
        let user = FIRAuth.auth()?.currentUser
        let currentUser = user?.uid
        if (self.uid == currentUser) {
            cell.answerTextView.isEditable = true
            cell.saveButton.isHidden = false
        }
        else {
            cell.answerTextView.isEditable = false
            cell.saveButton.isHidden = true
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
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
            self.tableView.reloadData()
        })
        tableView.reloadData()
    }

    func logout(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "profileLogoutSegue", sender: self)
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
