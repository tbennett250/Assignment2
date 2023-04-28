//
//  Task.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import Foundation

struct Task: Codable {
    var id: Int?
    var name: String
    var description: String
    var due_date: String
    var project_id: Int
    var status: Int
}
