//
//  Models.swift
//  Notaly
//
//  Created by Ronnie Kissos on 11/13/23.
//

import Foundation

struct Note: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var content: String
}
