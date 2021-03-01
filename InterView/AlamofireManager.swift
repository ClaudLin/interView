//
//  AlamofireManager.swift
//  InterView
//
//  Created by 19003471Claud on 2021/2/26.
//

import Foundation
import Alamofire

public func alamofire(urlStr:String ,completion: @escaping((Data?) -> Void)){
    AF.request(urlStr).response(completionHandler: { response in
        switch response.result {
        case .success(let data):
            completion(data)
        case .failure(let e):
            print(e)
            completion(nil)
        }
    })
}

