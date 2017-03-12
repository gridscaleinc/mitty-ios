//
//  SmartForm.swift
//  mitty
//
//  Created by gridscale on 2017/02/27.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

import UIKit
import PureLayout

// MARK: Operators

precedencegroup FormPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

precedencegroup SectionPrecedence {
    associativity: left
    higherThan: FormPrecedence
}

infix operator +++ : FormPrecedence
infix operator <<< : SectionPrecedence
prefix operator +=

@objc(CollectionForm)
class CollectionForm : MittyForm {
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = false
        
        let v = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    } ()
    
    init () {
        super.init(frame: CGRect.zero)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RowCell2.self, forCellWithReuseIdentifier: RowCell2.id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configLayout() {
        
    }
}

extension CollectionForm : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - 20 )
        let cellSize: CGSize = CGSize( width: width, height:30 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch(section){
        case 0:
            return CGSize(width: 300, height: 20)
        default:
            return CGSize(width: 300, height: 20)
        }
    }
    
}

extension CollectionForm: UICollectionViewDataSource {
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    // あるセクションから行を取得。
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell2.id, for: indexPath)
        var cell = collectionViewCell as! RowCell2
        
        let s = indexPath.section
        let r = indexPath.row
        let row = sections[s][r]
        
        return cell <<< row
    }
    
}

@objc(Page)
class Page2: Form2 {
    
    internal var sections : [Section2] = []
    internal var secDic : [String: Section2] = [:]
    
    func append(_ section: Section2) {
        sections.append(section)
        secDic[section.name] = section
    }
    
    subscript (_ index: Int) -> Section2 {
        return sections[index]
    }
    
    subscript (_ secName: String) -> Section2? {
        return secDic[secName]
    }
    
    subscript (_ s: Int, _ r: Int) -> Row2 {
        return sections[s][r]
    }
    
    subscript (_ secName: String, _ fieldName: String ) -> Control2? {
        return secDic[secName]?[fieldName]
    }
    
    @discardableResult
    static func +++ (left: Page2, right: Section2) -> Page2 {
        left.append(right)
        return left
    }
    
    static func <<< (left: Page2, right: Row2) -> Page2 {
        let s = left.sections
        if (s.count > 0) {
            let section = s[s.count - 1];
            section +++ right
            return left
        } else {
            let section = Section2() // 名前なしセクションを作成
            left +++ section
            section +++ right
            return left
        }
        
    }
    
    
    static func  += (left : inout Page2, section: Section2) {
        left.append(section)
    }
}



// Collection of rows
@objc(Section)
class Section2:NSObject  {
    private var rows : [Row2] = []
    private var _name : String = ""
    var name : String {
        get {
            return _name
        }
        set (newName) {
            _name = newName
        }
    }
    
    convenience override init () {
        self.init(name: "UNKNOWN")
    }
    
    init (name: String) {
        self._name = name
    }
    
    func append(_ r: Row2) {
        rows.append(r)
    }
    
    var count : Int {
        return rows.count
    }
    
    subscript (_ index: Int) -> Row2 {
        return rows[index]
    }
    
    subscript (_ fieldName: String) -> Control2? {
        for r in rows {
            let f = r[fieldName]
            if ( f != nil ) {
                return f
            }
        }
        return nil
    }
    
    @discardableResult
    static func +++ (left: Section2, right: Row2) -> Section2 {
        left.append(right)
        return left
    }
    
}

@objc(RowCell)
class RowCell2 : UICollectionViewCell {
    static let id : String = "SMART-CELL"
    override func prepareForReuse() {
        for f in subviews {
            f.removeFromSuperview()
        }
    }
    
    @discardableResult
    static func <<< (left: inout RowCell2, right: Container) -> RowCell2 {
        for (control) in right.children {
            left.addSubview(control.view)
        }
        right.configLayout()
        left.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return left
    }
    
}

@objc(Row)
class Row2:NSObject {
    internal var controlDic : [String: Control2] = [:]
    
    subscript (_ fieldName:String) -> Control2? {
        return controlDic[fieldName]
    }
    
    var count : Int {
        return controlDic.count
    }
    
    @discardableResult
    static func <<< (left: Row2, right: Row2) -> Row2 {
        left.controlDic = right.controlDic
        return left
    }
    
    @discardableResult
    static func +++ (left: Row2, right: Control2) -> Row2 {
        left.controlDic[right.name] = right
        return left
    }
    
    @discardableResult
    static func +++ (left: Row2, right: ()->Control2) -> Row2 {
        let c = right()
        return left+++c
    }
    
}

