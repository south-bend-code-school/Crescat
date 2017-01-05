//
//  HomeVC.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/22/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    // don't forget to hook this up from the storyboard
    @IBOutlet weak var tableView: UITableView!
    
    var professionalArray: [[String:AnyObject]] = []
    var questionArray: [[String:AnyObject]] = []
    var followeesArray: [String] = []
    
    /*
    let titles: [String] = ["Bernie Sanders", "Alexandria Viegut", "Barack Obama", "Queen Elizabeth II"]
    let questions: [String] = ["Q: Why did you choose deloitte?", "Q: What is your proudest achievement?", "Q: What is the best advice you've ever received?", "Q: Why Notre Dame?"]
    let answers: [String] = ["A: I really wanted to do consulting, it sounds super fun and awesome and they pay really well and I love being social and food!", "A: I went skydiving once and it was awesome, conquered ALL the fears and it was great bonding!", "A: Go to college, don't do drugs.", "A: Because Notre Dame has the best community ever, duh!"]
    let dates: [String] = ["1/2/17", "12/13/16", "12/1/16", "11/15/16"]
    */
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call firebase to get the Q/A of profs that this user is following
        //getListOfFollowees() no called from viewDidAppear
        //getQuestionsAndAnswers() now called from getListOfFollowees
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // set row height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // display current user's email
        let user = FIRAuth.auth()?.currentUser
        self.userEmailLabel.text = user?.email
        
        getProfessionalsList() // gets full list of professionals for searching
    }
    
    
    // need this here in order to reload tableview after switching prof followees
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       print("VIEW APPEARING!")

        getListOfFollowees()
        tableView.reloadData()
    }
    
    
    func getListOfFollowees() {
        followeesArray = [] // reset list of followees
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userPath = "users/" + userID!
        let usersRef = FIRDatabase.database().reference(withPath: userPath)
        
        usersRef.observe(.childAdded, with: { snapshot in
            print(snapshot.value)
            
            if (snapshot.hasChild("listOfFollowees")) {
                
                let json = snapshot.value as! [String:AnyObject]
                let listOfFollowees = json["listOfFollowees"] as! [String]
                print("is following these profs:")
                print(listOfFollowees)
                self.followeesArray = listOfFollowees
            }
            else {
                // is following no one
                print("user is not following anyone")
            }
        })
        
        getQuestionsAndAnswers() // great, now use this list to get the questions and answers
    }
    
    
    
    
    
    func getQuestionsAndAnswers() {
        questionArray = [] // reset question array
        
        //let questionsRef = FIRDatabase.database().reference(withPath: "questions")
        let questionsRef = FIRDatabase.database().reference(withPath: "questions").queryOrdered(byChild: "date")
        
        questionsRef.observe(.childAdded, with: { snapshot in
            
            let json = snapshot.value as! [String:AnyObject]
            
            // check if following this prof, if so then put question in array to be displayed
            if (self.followeesArray.contains(json["uid"] as! String)) {
        
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
            else {
                print("user is NOT following this prof")
            }
            
            print("printing question array")
            print(self.questionArray)
            print(self.questionArray.count)
            self.tableView.reloadData()
        })
    }
    
    func getProfessionalsList() {

        let usersRef = FIRDatabase.database().reference(withPath: "users")
        
        usersRef.observe(.childAdded, with: { snapshot in
            
            let json = snapshot.value as! [String:AnyObject]
            
            // storing UID under userInfo also, makes following easier
            print(snapshot.key)
            let userID = snapshot.key
            
            
            let userInfo = json["userInfo"] as! [String:AnyObject]
            
            if (userInfo["isProfessional"] as! Bool) {
                var prof: [String:String] = [:]
                
                let uid = userID
                let name = userInfo["name"] as! String
                let company = userInfo["company"] as! String
                let position = userInfo["position"] as! String
                let industry = userInfo["industry"] as! String
                let location = userInfo["location"] as! String
                let school = userInfo["school"] as! String
                
                prof["uid"] = uid
                prof["name"] = name
                prof["company"] = company
                prof["position"] = position
                prof["industry"] = industry
                prof["location"] = location
                prof["school"] = school

                self.professionalArray.append(prof as [String : AnyObject])
            }
            
            //print(self.professionalArray)
            
        })
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionArray.count
        //return self.questions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
        
/*
        cell.myCellQuestion.text = self.questions[indexPath.row]
        cell.myCellAnswer.text = self.answers[indexPath.row]
        cell.myCellDate.text = self.dates[indexPath.row]
        cell.myCellTitle.text = "  " + self.titles[indexPath.row] + " answered a question"
*/
        
        let thisQuestion = self.questionArray[indexPath.row]
        let name = thisQuestion["profName"] as! String?
        let question = thisQuestion["question"] as! String?
        let answer = thisQuestion["answer"] as! String?
        
        cell.myCellQuestion.text = "Q: " + question!
        cell.myCellAnswer.text = "A: " + answer!
        cell.myCellDate.text = thisQuestion["date"] as! String?
        cell.myCellTitle.text = " " + name! + " answered a question"
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let cell:MyCustomCell = tableView.cellForRow(at: indexPath) as! MyCustomCell
        cell.myCellTitle.backgroundColor = UIColor.darkGray
        
        // now go to that professional's profile page
        self.performSegue(withIdentifier: "homeToProfessional", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "searchProfessionals") {
            let yourNextViewController = (segue.destination as! SearchViewController)
            yourNextViewController.professionalArray = self.professionalArray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        //return UITableViewAutomaticDimension
    }

    
    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "homeLogoutSegue", sender: self)
    }

    @IBAction func searchButton(_ sender: Any) {
        // reset tableview arrays so can adjust to new data after (un)follows new profs
        
        self.performSegue(withIdentifier: "searchProfessionals", sender: self)
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
