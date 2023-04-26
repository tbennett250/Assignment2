//
//  ListAllProjectsViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 26/04/2023.
//

import UIKit

class ListAllProjectsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = UserData.shared.currentUser!.id
        
        
        let url = URL(string: "http://localhost:5000/api/projects/get/byuserid?id=\(userId)")
        
        var projects: [Project] = []
        
        URLSession.shared.fetchData(for: url!) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let results):
                projects.append(contentsOf: results)
            case .failure(let error):
                print(error)
            }
            
            var projectText = ""
            projects.forEach { project in
                            projectText += "Project Name: \(project.name)\n"
                            projectText += "Project Id \(project.id)\n"
                            projectText += "Start Date: \(project.start_date) |  End Date: \(project.end_date)\n"
                            projectText += "User Id \(project.user_id)\n"
                            projectText += "Description: \(project.description)\n\n"
            }
            print(projectText)
            
            DispatchQueue.main.async {
                self.textView.text = projectText
            }
           
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
