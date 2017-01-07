//
//  ViewController.swift
//  crescat
//
//  Created by Madelyn Nelson on 12/27/16.
//  Copyright © 2016 Madelyn Nelson. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var uid:String!
    var name:String!
    var position:String!
    var company:String!
    var location:String!
    var industry:String!
    var school:String!
    
    var questionArray: [[String:AnyObject]] = []
    
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
        
        filterQuestions()
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
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
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
