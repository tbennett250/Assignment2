//
//  ListAllTasksViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 12/04/2023.
//

import UIKit

class ListAllTasksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func fetchTaskDetails(forUserId: UserData.shared.currentUser!.id){
        let apiUrl = "http://120.0.0.1:5000/api/"
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
