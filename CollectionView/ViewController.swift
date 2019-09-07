//
//  ViewController.swift
//  CollectionView
//
//  Created by Dongwoo Pae on 9/7/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addButton: UIBarButtonItem!  //this is outlet to control the UI of the addbarbutton
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    var collectionData = ["1🏀", "2🥅", "3🥎", "4🏀", "5🥅", "6🥎","7🏀", "8🥅", "9🥎","10🏀", "11🥅", "12🥎","13🏀", "14🥅", "15🥎"]
    
    
    @IBAction func addItem() {  //this
        collectionView.performBatchUpdates({
            for _ in 0 ..< 2 {
            let text = "\(collectionData.count + 1)⚾️"
            collectionData.append(text)
            //after appending total number of data would be 16 but item should be added in 15 since it starts index at 0 so it needs to be deducted one
            let indexPath = IndexPath(row: collectionData.count-1, section: 0)
            collectionView.insertItems(at: [indexPath])
            }
        }, completion: nil)
    }
    
    @IBAction func deleteItem() {
        if let indexPaths = collectionView.indexPathsForSelectedItems {  //[1,2,3]
            let reversedIndexPaths = indexPaths.sorted().reversed()   // [3,2,1]
        for indexPath in reversedIndexPaths {
                collectionData.remove(at: indexPath.item)
            }
            collectionView.deleteItems(at: indexPaths)  //indexPaths does not need to be wrapped in an array since indexPaths itself is an array
        }
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addButton.isEnabled = !editing
        collectionView.allowsMultipleSelection = editing
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        deleteButton.isEnabled = editing
        if !editing {
            navigationController?.isToolbarHidden = true
        }
    }
    
    @objc func refresh() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let destVC = segue.destination as? DetailViewController,
                //this code below replaces selectedItem since we are using didSecteItemAtabove
                let index = sender as? IndexPath {
                destVC.selection = collectionData[index.item]
            }
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selected = collectionView.indexPathsForSelectedItems,
            selected.count == 0 {
            navigationController?.isToolbarHidden = true
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text  = collectionData[indexPath.item]
        cell.isEditing = isEditing
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
        // segue is connected directly through viewcontroller not from the cell then use this way using sender to be indexPath
        performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }

    
}
