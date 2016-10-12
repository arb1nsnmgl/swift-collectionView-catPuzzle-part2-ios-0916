//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GameKit


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerReusableView: HeaderReusableView!
    var footerReusableView: FooterReusableView!
    var sectionInsets: UIEdgeInsets!
    var spacing: CGFloat!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var imageSlices = [UIImage]()
    var arranged = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        generateImage()
        configureLayout()
        randomize()
        print("\n")
        print(imageSlices)
    }
    
    func generateImage() {
        for i in 1...12 {
            imageSlices.append(UIImage(named: "\(i)")!)
        }
        arranged = imageSlices
        print(arranged)
    }
    
    func randomize() {
        imageSlices = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: imageSlices) as! [UIImage]
        
    }
    
    func configureLayout() {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        numberOfRows = 4
        numberOfColumns = 3
        spacing = 2
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        referenceSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        itemSize = CGSize(width: width/numberOfColumns - 3, height: height/numberOfRows - 34)
    
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = imageSlices[indexPath.row]
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        footerReusableView.startTimer()
        let removed = imageSlices.remove(at: sourceIndexPath.item)
        imageSlices.insert(removed, at: destinationIndexPath.item)
        
        if imageSlices == arranged {
            let footer = footerReusableView
            footer?.timer.invalidate()
            performSegue(withIdentifier: "solvedSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "solvedSegue" { return }
        if let dest = segue.destination as? SolvedViewController {
            dest.image = UIImage(named: "cats")
            dest.time = footerReusableView.timerLabel.text
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView
            
            return headerReusableView
            
        } else {
            
            footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView
           
            footerReusableView.timerLabel.text = "00:00"
            return footerReusableView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    
}
