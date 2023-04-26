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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frmStartDate.datePickerMode = .date
        frmEndDate.datePickerMode = .date
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
        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)
        
        print(title)
        print(desc)
        print(formattedStartDate)
        print(formattedEndDate)
        
        
        let parameters = ["name" : title,
                          "description" :  desc,
                          "start_date" : formattedStartDate,
                          "end_date" : formattedEndDate,
                          "user_id" : UserData.shared.currentUser!.id] as [String : Any]
        
        let url = URL(string: "localhost/api/projects/add")
        
        var project = Project(id: nil, name: title, description: desc, start_date: formattedStartDate, end_date: formattedEndDate, user_id: UserData.shared.currentUser!.id)
        
        
        URLSession.shared.postData(project, urlString: url) { result:[Project] in
            <#code#>
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
