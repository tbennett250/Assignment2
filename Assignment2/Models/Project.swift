//
//  Project.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 26/04/2023.
//

import Foundation

struct Project: Codable, Identifiable{
    var id: Int?
    var name : String
    var description: String
    var start_date: String
    var end_date: String
    var user_id: Int
    //var isComplete: Bool = false
    
}
