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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: dateCellLayout())
        collectionView.dataSource = self
        
        collectionView.register(
            CalendarDateComponent.self,
            forCellWithReuseIdentifier: CalendarDateComponent.identifier
        )
        
        return collectionView
    }()
    
    let cm = CalendarManager()
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setSubViews()
        
        cm.updateDatePublisher
            .sink { [weak self] c in
                print(c.date)
            }.store(in: &subscription)
        
    }
    
    private func setSubViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func dateCellLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 7),
            heightDimension: .absolute(73)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(73)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateComponent.identifier,
            for: indexPath
        ) as? CalendarDateComponent else {
            return UICollectionViewCell()
        }
        
        cell.configureView(date: "1", insidePercentage: 0.3, outsidePercentage: 0.2)
        if indexPath.row == 4 {
            cell.select(isSelect: true)
        }
        
        return cell
    }
}
