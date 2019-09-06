//
//  ViewController.swift
//  CollectionView
//
//  Created by Dongwoo Pae on 9/7/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var collectionData = ["🏀", "🥅", "🥎", "🏀", "🥅", "🥎","🏀", "🥅", "🥎","🏀", "🥅", "🥎","🏀", "🥅", "🥎"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = collectionData[indexPath.item]
        }
        return cell
    }
}
