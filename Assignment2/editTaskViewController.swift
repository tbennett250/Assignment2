//
//  editTaskViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import UIKit

class editTaskViewController: UIViewController {
    
    @IBOutlet weak var frmName: UITextField!
    @IBOutlet weak var frmDesc: UITextField!
    @IBOutlet weak var frmDate: UIDatePicker!
    @IBOutlet weak var lblProjectTitle: UILabel!
    @IBOutlet weak var msgImage: UIImageView!
    @IBOutlet weak var msgLabel: UILabel!
    var taskId : Int?
    var projectTitle: String?
    var projectId: Int?
    
    let dateFormatter = DateFormatter()
    
    
    
    
    func setErrorMsg(message: String){
        DispatchQueue.main.async {
            self.msgLabel.textColor = .red
            self.msgLabel.text = message
            self.msgImage.image = UIImage(named: "cancel")
        }
    }
    
    func setSuccessMsg(msg: String){
        DispatchQueue.main.async {
            self.msgLabel.textColor = .green
            self.msgLabel.text = msg
            self.msgImage.image = UIImage(named: "accept")
        }
        
    }
    
    
    
    
    
    
    @IBOutlet weak var statusControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgLabel.text = ""
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.lblProjectTitle.text = projectTitle
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
                  let project_id = currentTask?.project_id,
                  let status = currentTask?.status else{
                print("error converting variables")
                      self.setErrorMsg(message: "Error getting Data")
                return
            }
            // Set date to a suitable value to be accessed by date picker
            //Format date
            let dateDB = self.dateFormatter.date(from: due_date)
            self.projectId = project_id
            DispatchQueue.main.async {
                self.statusControl.selectedSegmentIndex = status
                self.frmDate.date = dateDB ?? Date()
                self.frmDesc.text = description
                self.frmName.text = name
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
    @IBAction func btnUpdatePressed(_ sender: Any) {
        //get data from form
        guard let nameUpdate = frmName.text,
              let descUpdate = frmDesc.text,
              let datepicked = frmDate?.date
        else{
            self.setErrorMsg(message: "ERROR - Please ensure all fields are filled")
            return
        }
        
        let dateUpdate = self.dateFormatter.string(from: datepicked)
        
        let statusUpdate = self.statusControl.selectedSegmentIndex
              
        var task = Task( id: self.taskId! , name: nameUpdate, description: descUpdate, due_date: dateUpdate, project_id: self.projectId! , status: statusUpdate)
        print("proj id")
        print(self.projectId!)
        print(task)
        let url = "http://127.0.0.1:5000/api/tasks/update"
        
        URLSession.shared.postData(task, urlString: url) {(result: Result<Task, Error>) in
            
            switch result {
            case.success(let result):
                print(result)
                self.setSuccessMsg(msg: "Task Updated")
                
            case.failure(let error):
                print(error.localizedDescription)
                self.setErrorMsg(message: "Update was Unsuccessful")
            }
            
        }
    }
    
    
    @IBAction func btnDeletePressed(_ sender: Any) {
        
        
        let apiUrl = URL(string: "http://127.0.0.1:5000/api/tasks/delete/\(self.taskId!)")!
          var request = URLRequest(url: apiUrl)
          request.httpMethod = "DELETE"
          
          // Create a URLSession data task to send the DELETE request to the API endpoint
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  print("Error: \(error.localizedDescription)")
                  
                  return
              }
              if let response = response as? HTTPURLResponse {
                  if response.statusCode == 200 {
                      print("Task deleted successfully.")
                      
                      DispatchQueue.main.async {
                          
                          
                          let UserVC = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                          self.navigationController?.pushViewController(UserVC, animated: true)
                      }
                      
                      
                      
                   
                  } else {
                      print("Error: HTTP status code \(response.statusCode)")
                      
                  }
              }
          }
          // Start the data task
          task.resume()
      }
        
    
 
    
    
    }
    

