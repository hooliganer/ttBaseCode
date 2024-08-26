//
//  BaseCollectionFlowLayout.swift
//  ttBaseCode
//
//  Created by 谭滔 on 2024-08-26.
//

import UIKit

public class BaseCollectionLayout: UICollectionViewFlowLayout {
    public enum AlignType {
        case left
        case center
        case right
    }
    
    /// 两个Cell之间的距离
    public var betweenOfCell: CGFloat {
        didSet {
            minimumInteritemSpacing = betweenOfCell
        }
    }
    
    /// cell对齐方式
    public var cellType: AlignType = .center
    
    /// 在居中对齐的时候需要知道这行所有cell的宽度总和
    var sumCellWidth: CGFloat = 0.0
    
    override init() {
        betweenOfCell = 5.0
        super.init()
        scrollDirection = .vertical
        minimumLineSpacing = 5
        sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    public convenience init(_ cellType: AlignType) {
        self.init()
        self.cellType = cellType
    }
    
    public convenience init(_ cellType: AlignType, _ betweenOfCell: CGFloat) {
        self.init()
        self.cellType = cellType
        self.betweenOfCell = betweenOfCell
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superLayout: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        guard let layoutAttributes = NSArray(array: superLayout, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
            return superLayout
        }
        var layoutArray = [UICollectionViewLayoutAttributes]()
        for (index, currentAttr) in layoutAttributes.enumerated() {
            let previousAttr = index == 0 ? nil : layoutAttributes[index - 1]
            let nextAttr = index + 1 == layoutAttributes.count ?
            nil : layoutAttributes[index + 1]
            
            layoutArray.append(currentAttr)
            sumCellWidth += currentAttr.frame.size.width
            
            let previousY: CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY: CGFloat = currentAttr.frame.maxY
            let nextY: CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY, currentY != nextY {
                let headerKind: String
                let footerKind: String
#if swift(>=4.2)
                headerKind = UICollectionView.elementKindSectionHeader
                footerKind = UICollectionView.elementKindSectionFooter
#else
                headerKind = UICollectionElementKindSectionHeader
                footerKind = UICollectionElementKindSectionFooter
#endif
                if currentAttr.representedElementKind == headerKind {
                    layoutArray.removeAll()
                    sumCellWidth = 0.0
                } else if currentAttr.representedElementKind == footerKind {
                    layoutArray.removeAll()
                    sumCellWidth = 0.0
                } else {
                    setCellFrame(with: layoutArray)
                    layoutArray.removeAll()
                    sumCellWidth = 0.0
                }
            } else if currentY != nextY {
                setCellFrame(with: layoutArray)
                layoutArray.removeAll()
                sumCellWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    private func setCellFrame(with layoutAttributes: [UICollectionViewLayoutAttributes]) {
        guard let collectionView = collectionView else { return }
        var leftX: CGFloat = 0.0
        switch cellType {
        case .left:
            leftX = sectionInset.left
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = leftX
                attributes.frame = nowFrame
                leftX += nowFrame.size.width + betweenOfCell
            }
        case .center:
            leftX = (collectionView.frame.size.width - sumCellWidth - (CGFloat(layoutAttributes.count - 1) * betweenOfCell)) / 2
            for attributes in layoutAttributes {
                var nowFrame = attributes.frame
                nowFrame.origin.x = leftX
                attributes.frame = nowFrame
                leftX += nowFrame.size.width + betweenOfCell
            }
        case .right:
            leftX = collectionView.frame.size.width - sectionInset.right
            for var index in 0 ..< layoutAttributes.count {
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = leftX - nowFrame.size.width
                attributes.frame = nowFrame
                leftX = leftX - nowFrame.size.width - betweenOfCell
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
