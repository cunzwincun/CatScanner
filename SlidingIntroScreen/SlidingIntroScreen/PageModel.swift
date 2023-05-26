//
//  PageModel.swift
//  SlidingIntroScreen
//
//  Created by Federico on 18/03/2022.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Group2", description: "This is a sample description for the purpose of debugging", imageUrl: "work", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "Welcome to Cat Scanner!", description: "Use your camera or upload your own photo from the gallery to identify cat breeds within seconds", imageUrl: "catlogo", tag: 0),
        Page(name: "We need Access", description: "To identify cat breeds, we need access to the camera and gallery of your device. Push notifications are helpful for our community features", imageUrl: "Group1", tag: 1),
        Page(name: "Ensure image quality!", description: "Try to take a picture of the whole body. At least the head should be visible!", imageUrl: "Group2", tag: 2),
        Page(name: "Upload your Cat’s photo", description: "Try to take a picture of the whole body. At least the head should be visible!", imageUrl: "folder", tag: 3),
    ]
}
