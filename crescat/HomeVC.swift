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
    
    // These strings will be the data for the table view cells
    let titles: [String] = ["Bernie Sanders", "Alexandria Viegut", "Barack Obama", "Queen Elizabeth II"]
    let questions: [String] = ["Q: Why did you choose deloitte?", "Q: What is your proudest achievement?", "Q: What is the best advice you've ever received?", "Q: Why Notre Dame?"]
    let answers: [String] = ["A: I really wanted to do consulting, it sounds super fun and awesome and they pay really well and I love being social and food!", "A: I went skydiving once and it was awesome, conquered ALL the fears and it was great bonding!", "A: Go to college, don't do drugs.", "A: Because Notre Dame has the best community ever, duh!"]
    let dates: [String] = ["1/2/17", "12/13/16", "12/1/16", "11/15/16"]
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // set row height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // display current user's email
        let user = FIRAuth.auth()?.currentUser
        self.userEmailLabel.text = user?.email
        
        getProfessionalsList()
    }
    
    func getProfessionalsList() {

        let usersRef = FIRDatabase.database().reference(withPath: "users")
        
        usersRef.observe(.childAdded, with: { snapshot in
            
            let json = snapshot.value as! [String:AnyObject]
            
            let userInfo = json["userInfo"] as! [String:AnyObject]
            var professionalArray: [[String:AnyObject]] = []
            
            
            if (userInfo["isProfessional"] as! Bool) {
                var prof: [String:String] = [:]
                
                let name = userInfo["name"] as! String
                let company = userInfo["company"] as! String
                let position = userInfo["position"] as! String
                let industry = userInfo["industry"] as! String
                let location = userInfo["location"] as! String
                let school = userInfo["school"] as! String
                
                prof["name"] = name
                prof["company"] = company
                prof["position"] = position
                prof["industry"] = industry
                prof["location"] = location
                prof["school"] = school

                professionalArray.append(prof as [String : AnyObject])
            }
            
            print(professionalArray)
            
        })
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell

        cell.myCellQuestion.text = self.questions[indexPath.row]
        cell.myCellAnswer.text = self.answers[indexPath.row]
        cell.myCellDate.text = self.dates[indexPath.row]
        cell.myCellTitle.text = "  " + self.titles[indexPath.row] + " answered a question"

        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
        //return UITableViewAutomaticDimension
    }

    
    @IBAction func logout(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: "homeLogoutSegue", sender: self)
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
