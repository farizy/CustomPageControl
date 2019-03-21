//
//  ViewController.swift
//  CustomPageControl
//
//  Created by MAC on 20/03/19.
//  Copyright © 2019 frzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(
                UINib(nibName: "ColorCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "ColorCollectionViewCell"
            )
            collectionView.isPagingEnabled = true
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var customPageControl: CustomPageControl!
    
    let colors: [UIColor] = [
        UIColor.red,  UIColor.orange, UIColor.yellow, UIColor.green,
        UIColor.cyan, UIColor.blue, UIColor.black, UIColor.gray
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        customPageControl.numberOfPages = colors.count
        customPageControl.currentPage = 0
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        let color = colors[indexPath.row]
        cell.setColor(color: color)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        let size = CGSize(width: height, height: width)
        
        return size 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
        customPageControl.currentPage = indexPath.row
    }
}
