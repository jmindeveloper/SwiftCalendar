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
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(
            CalendarRingCell.self,
            forCellWithReuseIdentifier: CalendarRingCell.identifier
        )
        
        collectionView.register(
            CalendarHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CalendarHeader.identifier
        )
        
        return collectionView
    }()
    
    let vm = CalendarViewModel()
    
    private var sectionCount = 5
    
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        binding()
        setSubViews()
    }
    
    private func binding() {
        vm.updateCollectionViewPublisher
            .sink { [weak self] in
                self?.collectionView.reloadData()
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
        section.boundarySupplementaryItems = [header()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func header() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(65)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return header
    }
    
    var aa = false

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.component.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarRingCell.identifier,
            for: indexPath
        ) as? CalendarRingCell else {
            return UICollectionViewCell()
        }
        
        let day = vm.component[indexPath.row].day
        cell.configureView(date: day, insidePercentage: 0.3, outsidePercentage: 0.2)
        if indexPath.row == 4 {
            cell.select(isSelect: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarHeader.identifier, for: indexPath) as? CalendarHeader else {
                return UICollectionReusableView()
            }
            header.setLabel(text: "2022년 12월")
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            sectionCount += 1
            collectionView.reloadData()
        } else if collectionView.contentOffset.y < 0 {
            if !aa {
                print("🧐", collectionView.contentOffset.y)
                sectionCount += 1
                print("🧐sectionCount", sectionCount)
                collectionView.reloadData()
                print("🧐before offset y", collectionView.contentOffset.y)
                
                
                let scrollOffset = scrollView.contentSize.height - scrollView.contentOffset.y
                
                print("🧐scrollOffset", scrollOffset)
                
                // 438은 현재 section의 height
                // TODO: - 추후 섹션높이 구하는 메서드 추가해야함
                scrollView.contentOffset = CGPoint(
                    x: scrollView.contentOffset.x,
                    y: scrollView.contentSize.height - scrollOffset + 438)
                
                print("🧐after offset y", scrollView.contentOffset.y)
                print("🧐---")
            }
        }
    }
}

final class CalendarHeader: UICollectionReusableView {
    
    static let identifier = "CalendarHeader"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(text: String) {
        self.label.text = text
    }
}
