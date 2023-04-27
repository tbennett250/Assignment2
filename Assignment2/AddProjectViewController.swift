//
//  AddProjectViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 26/04/2023.
//

import UIKit

class AddProjectViewController: UIViewController {

    
    @IBOutlet weak var frmTitle: UITextField!
    
    @IBOutlet weak var frmDescription: UITextField!
    
    @IBOutlet weak var frmStartDate: UIDatePicker!
    
    @IBOutlet weak var frmEndDate: UIDatePicker!
    
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgMsg: UIImageView!
    
    
    func setErrorMsg(message: String){
        DispatchQueue.main.async {
            self.lblMsg.textColor = .red
            self.lblMsg.text = message
            self.imgMsg.image = UIImage(named: "cancel")
        }
    }
    
    func setSuccessMsg(msg: String){
        DispatchQueue.main.async {
            self.lblMsg.textColor = .green
            self.lblMsg.text = msg
            self.imgMsg.image = UIImage(named: "accept")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frmStartDate.datePickerMode = .date
        frmEndDate.datePickerMode = .date
        self.lblMsg.text = ""
        // Do any additional setup after loading the view.
        
        
    }
    

    @IBAction func btnSubmitPressed(_ sender: Any) {
           
        guard let title = frmTitle.text,
              let desc = frmDescription.text,
              let startDate = frmStartDate?.date,
              let endDate = frmEndDate?.date else {
            return
        }
        
      
        // format dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //extract just the date from the date boxes and we are getting time aswell
        let todaysDate = Date()
        let formattedTodaysDate = dateFormatter.string(from: todaysDate)
        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)
        
        guard formattedTodaysDate.compare(formattedStartDate) != .orderedDescending else{
            self.setErrorMsg(message: "Start date cannot be in the past.")
            return
        }
        
        guard formattedTodaysDate.compare(formattedEndDate) != .orderedDescending else {
            self.setErrorMsg(message: "End date cannot be in the past.")
            return
        }
        
        print(title)
        print(desc)
        print(formattedStartDate)
        print(formattedEndDate)
        
        //make sure start date isnt before today
      
        //put todays date in correct format
       
        
        
        let url =  "http://127.0.0.1:5000/api/projects/add"
        
        var project = Project(name: title, description: desc, start_date: formattedStartDate, end_date: formattedEndDate, user_id: UserData.shared.currentUser!.id)
        
        
        URLSession.shared.postData(project, urlString: url) { (result: Result<Project, Error>) in
            switch result {
            case.success(let result):
                print(result)
                self.setSuccessMsg(msg: "Project Added, Please Return")
                
            case.failure(let error):
                print(error.localizedDescription)
                self.setErrorMsg(message: "Error adding product, Please try again")
                
            }
        }
        
        
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
