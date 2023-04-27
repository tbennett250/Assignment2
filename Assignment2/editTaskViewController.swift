//
//  editTaskViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import UIKit

class editTaskViewController: UIViewController {
    
    var taskId : Int?
    var projectTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ensure variable has been passed
        
        guard let id = taskId else{
            print("Id not passed")
            return
        }
        
        print("Id passed")
        print(id)
        
        
        let url = URL(string: "http://localhost:5000/api/tasks/get/byid?id=\(id)")
        
        var currentTask: Task?

        URLSession.shared.fetchData(for: url!) { (result: Result<[Task], Error>) in
            switch result {
            case .success(let results):
                if let firstResult = results.first {
                    currentTask = firstResult
                } else {
                    print("No task found")
                }
            case .failure(let error):
                print(error)
                print("ERROR")
            }
            
            print(currentTask!)
            
            guard let name = currentTask?.name,
                  let description = currentTask?.description,
                  let due_date = currentTask?.due_date,
                  let status = currentTask?.status,
                  let project_id = currentTask?.project_id else{
                return
            }
            
            print(self.projectTitle!)
            print(name)
            print(description)
            print(due_date)
            print(status)
            print(project_id)
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
    
}
