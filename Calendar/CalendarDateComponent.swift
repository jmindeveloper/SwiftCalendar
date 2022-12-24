//
//  CalendarDateComponent.swift
//  Calendar
//
//  Created by J_Min on 2022/12/24.
//

import UIKit
import SnapKit

final class CalendarDateComponent: UICollectionViewCell {
    
    static let identifier = "AIMCareMSKCalendarRing"
    
    private let ringBaseView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "목"
        label.textAlignment = .center
        
        return label
    }()
    
    private let dateLabelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 21 / 2
        view.isHidden = true
        
        return view
    }()
    
    private let ringMainLayer = CALayer()
    private let insideRingLayer = CAShapeLayer()
    private let insideRingPath = UIBezierPath()
    private let outsideRingLayer = CAShapeLayer()
    private let outsideRingPath = UIBezierPath()
    
    private var insidePercentage: CGFloat = .zero
    private var outsidePercentage: CGFloat = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayers()
    }
    
    /// percentage --> 0 ~ 1%
    init(insidePercentage: CGFloat, outsidePercentage: CGFloat) {
        self.insidePercentage = insidePercentage
        self.outsidePercentage = outsidePercentage
        super.init(frame: .zero)
        setLayers()
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var firstDraw: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if ringBaseView.frame != .zero {
            drawInsideRing()
            drawOutsideRing()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        insideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        outsideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    // MARK: - Method
    func configureView(date: String, insidePercentage: CGFloat, outsidePercentage: CGFloat) {
        dateLabel.text = date
        self.insidePercentage = insidePercentage
        self.outsidePercentage = outsidePercentage
//        insideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
//        outsideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func select(isSelect: Bool) {
        if isSelect {
            dateLabelBackgroundView.isHidden = false
            dateLabel.textColor = .white
        } else {
            dateLabelBackgroundView.isHidden = true
            dateLabel.textColor = .black
        }
    }
    
    func enable(isEnable: Bool) {
        if isEnable {
            ringBaseView.alpha = 0.5
        } else {
            ringBaseView.alpha = 1
        }
    }
    
    // MARK: - Ring
    private func setLayers() {
        ringBaseView.layer.addSublayer(ringMainLayer)
        [insideRingLayer, outsideRingLayer].forEach {
            ringMainLayer.addSublayer($0)
        }
    }
    
    private func drawInsideRing() {
        insideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: ringBaseView.frame.width / 2, y: ringBaseView.frame.height / 2)
        let radius = CGFloat(ringBaseView.frame.width / 2 - 13)
//        let center = CGPoint(x: 23, y: 23)
//        let radius = CGFloat(23 - 13)
        
        insideRingPath.addArc(
            withCenter: center,
            radius: radius,
            startAngle: (-.pi / 2),
            endAngle: (.pi * 3 / 2),
            clockwise: true
        )
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = insideRingPath.cgPath
        trackLayer.strokeColor = UIColor.black.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 6
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = insideRingPath.cgPath
        progressLayer.strokeColor = UIColor.green.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6
        progressLayer.strokeEnd = insidePercentage
        progressLayer.lineCap = .round
        
        insideRingLayer.addSublayer(trackLayer)
        insideRingLayer.addSublayer(progressLayer)
    }
    
    private func drawOutsideRing() {
        outsideRingLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let center = CGPoint(x: ringBaseView.frame.width / 2, y: ringBaseView.frame.height / 2)
        let radius = CGFloat(ringBaseView.frame.width / 2 - 5)
//        let center = CGPoint(x: 23, y: 23)
//        let radius = CGFloat(23 - 5)

        outsideRingPath.addArc(
            withCenter: center,
            radius: radius,
            startAngle: (-.pi / 2),
            endAngle: (.pi * 3 / 2),
            clockwise: true
        )
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = outsideRingPath.cgPath
        trackLayer.strokeColor = UIColor.black.withAlphaComponent(0.3).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 6
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = outsideRingPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6
        progressLayer.strokeEnd = outsidePercentage
        progressLayer.lineCap = .round
        
        insideRingLayer.addSublayer(trackLayer)
        insideRingLayer.addSublayer(progressLayer)
    }

    
    // MARK: - UI
    private func setSubViews() {
        [dateLabelBackgroundView, dateLabel, ringBaseView].forEach {
            contentView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        dateLabel.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview().inset(2)
            $0.height.equalTo(21)
        }
        
        dateLabelBackgroundView.snp.makeConstraints {
            $0.center.equalTo(dateLabel)
            $0.size.equalTo(21)
        }
        
        ringBaseView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(2)
            $0.size.equalTo(46)
            $0.horizontalEdges.bottom.equalToSuperview().inset(2)
        }
    }
}

