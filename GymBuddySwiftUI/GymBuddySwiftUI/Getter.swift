//
//  Getter.swift
//  GymBuddySwiftUI
//
//  Created by Freddie Kohn on 14/04/2023.


import SwiftUI
import UIKit
import MobileCoreServices

//struct Getter_Previews: PreviewProvider {
//    static var previews: some View {
//        accountGetter()
//    }
//}

public struct Account: Codable {

    let id: Int

    let first_name: String

    let last_name: String

    let username: String

    let password: String

    let email: String
    
    let xp: Int 

}

//struct Exercise: Codable, Identifiable {
//    
//    let id: Int
//    
//    let type: String
//    
//    let datetime: String
//    
//    let account: Int
//    
//    let file: String
//    
//}


struct Workout: Codable, Identifiable {
    
    let id: Int
    
    let account: Int
        
    let startTime: String
    
    let endTime: String
    
    let title: String
    
    let description: String
    
    let xp: Int
    
}

