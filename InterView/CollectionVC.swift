//
//  CollectionVC.swift
//  InterView
//
//  Created by 19003471Claud on 2021/2/26.
//

import UIKit

class CollectionVC: UIViewController {
    
    private var collectionView: UICollectionView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout?
    private let imageCache : NSCache = NSCache<NSURL, UIImage>()
    private var spinner = UIActivityIndicatorView(style: .large)
    private var isLoading = false
    private var loadingView: LoadingReusableView?
    private var bookmarks:Int = 0
    private var addNum = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fetchImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { timer in
            self.UIInit()
        })
    }
    
    
    private func fetchImage() {
        isLoading = false
        if let array = CollectionInfo.sharedInstance.collectionViewModelInofArray {
            bookmarks += addNum
            for i in 0...bookmarks {
                if i <= array.count {
                    let imageUrl = array[i].thumbnailUrl
                    if imageUrl != nil && imageUrl != "" {
                        let url = NSURL(string: imageUrl!)
                        if imageCache.object(forKey: url!) == nil {
                            alamofire(urlStr: imageUrl!, completion: { imageData in
                                print("i \(i)")
                                if imageData != nil, let image = UIImage(data: imageData!) {
                                    self.imageCache.setObject(image, forKey: url!)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func fetchImageMore() {
        if !isLoading {
            isLoading = true
            if let array = CollectionInfo.sharedInstance.collectionViewModelInofArray {
                let start = bookmarks
                bookmarks += addNum
                if bookmarks > array.count - 1{
                    bookmarks = (array.count - 1)
                }
                DispatchQueue.global().async {
                    sleep(2)
                    for i in start...self.bookmarks {
                        let imageUrl = array[i].thumbnailUrl
                        if imageUrl != nil && imageUrl != "" {
                            let url = NSURL(string: imageUrl!)
                            if self.imageCache.object(forKey: url!) == nil {
                                alamofire(urlStr: imageUrl!, completion: { imageData in
                                    print("i \(i)")
                                    if imageData != nil, let image = UIImage(data: imageData!) {
                                        self.imageCache.setObject(image, forKey: url!)
                                    }
                                })
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    private func UIInit(){
        if spinner.isAnimating {
            spinner.stopAnimating()
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            let width = self.getFrame().width/3
            let height = self.getFrame().width/3
            collectionViewFlowLayout?.itemSize = CGSize(width: width , height: height)
            collectionViewFlowLayout?.minimumLineSpacing = 0
            collectionViewFlowLayout?.minimumInteritemSpacing = 0
            collectionView = UICollectionView(frame: self.getFrame(), collectionViewLayout: collectionViewFlowLayout!)
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.backgroundColor = .white
            collectionView?.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
            collectionView?.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
            view.addSubview(collectionView!)
        }
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

extension CollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return CollectionInfo.sharedInstance.collectionViewModelInofArray!.count
        return bookmarks
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == bookmarks - 9 && !isLoading {
            fetchImageMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.contentMode = .scaleAspectFill
        let row = indexPath.row
        if let array = CollectionInfo.sharedInstance.collectionViewModelInofArray {
            let imageUrl = array[row].thumbnailUrl
            if imageUrl != nil && imageUrl != ""{
                let url = NSURL(string: imageUrl!)
                if let image = self.imageCache.object(forKey: url!){
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
//                else {
//                    alamofire(urlStr: imageUrl!, completion: { imageData in
//                        if imageData != nil, let image = UIImage(data: imageData!) {
//                            self.imageCache.setObject(image, forKey: url!)
//                            DispatchQueue.main.async {
//                                cell.imageView.image = image
//                            }
//                        }
//                    })
//                }
            }
        }
        return cell
    }
    
}


