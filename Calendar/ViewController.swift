//
//  ViewController.swift
//  Calendar
//
//  Created by J_Min on 2022/12/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()
    
    let cm = CalendarManager()
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        cm.updateDatePublisher
            .sink { [weak self] c in
                print(c.date)
            }.store(in: &subscription)
        
    }

}

