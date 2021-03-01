//
//  ViewController.swift
//  InterView
//
//  Created by 19003471Claud on 2021/2/26.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadInfo()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        let VC = CollectionVC()
        navigationController?.pushViewController(VC, animated: false)
    }
    

    private func downloadInfo() {
        alamofire(urlStr: ApiURL.sharedInstance.apiurl, completion: { data in
            if let arraydata = data {
                do {
                    CollectionInfo.sharedInstance.collectionViewModelInofArray = try JSONDecoder().decode([collectionViewModelInfo].self, from: arraydata)
                } catch {
                    print("轉換json發生錯誤 \(error)")
                }
            } else {
                print("取api發生錯誤")
            }
        } )
    }
}

