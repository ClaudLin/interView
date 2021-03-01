//
//  ViewModel.swift
//  InterView
//
//  Created by 19003471Claud on 2021/2/26.
//

import Foundation
import UIKit
struct collectionViewModelInfo: Codable {
    
    let albumId: Int?
    let id: Int?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case id = "id"
        case title = "title"
        case url = "url"
        case thumbnailUrl = "thumbnailUrl"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        albumId = try value.decodeIfPresent(Int.self, forKey: .albumId)
        id = try value.decodeIfPresent(Int.self, forKey: .id)
        title = try value.decodeIfPresent(String.self, forKey: .title)
        url = try value.decodeIfPresent(String.self, forKey: .url)
        thumbnailUrl = try value.decodeIfPresent(String.self, forKey: .thumbnailUrl)
    }
    
}

class CollectionInfo {
    
    static let sharedInstance = CollectionInfo()
    
    private init(){
        print("CollectionInfo init")
    }
    var collectionViewModelInofArray: [collectionViewModelInfo]?
    
}



