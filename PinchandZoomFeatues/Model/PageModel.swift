//
//  PageModel.swift
//  PinchandZoomFeatues
//
//  Created by Narayanasamy on 24/08/23.
//

import Foundation

struct Page: Identifiable {
    
    let id: Int
    let imageName: String
}
extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
