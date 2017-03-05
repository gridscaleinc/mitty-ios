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
        collectionView.register(RowCell.self, forCellWithReuseIdentifier: RowCell.id)
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
        let width = ( screenSize.width - (10 * 3) )
        let cellSize: CGSize = CGSize( width: width, height:30 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
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
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RowCell.id, for: indexPath)
        var cell = collectionViewCell as! RowCell
        
        let s = indexPath.section
        let r = indexPath.row
        let row = sections[s][r]
        
        return cell <<< row
    }
    
}

@objc(Page)
class Page: Form {
    
    internal var sections : [Section] = []
    internal var secDic : [String: Section] = [:]
    
    func append(_ section: Section) {
        sections.append(section)
        secDic[section.name] = section
    }
    
    subscript (_ index: Int) -> Section {
        return sections[index]
    }
    
    subscript (_ secName: String) -> Section? {
        return secDic[secName]
    }
    
    subscript (_ s: Int, _ r: Int) -> Row {
        return sections[s][r]
    }
    
    subscript (_ secName: String, _ fieldName: String ) -> Control? {
        return secDic[secName]?[fieldName]
    }
    
    @discardableResult
    static func +++ (left: Page, right: Section) -> Page {
        left.append(right)
        return left
    }
    
    static func <<< (left: Page, right: Row) -> Page {
        let s = left.sections
        if (s.count > 0) {
            let section = s[s.count - 1];
            section +++ right
            return left
        } else {
            let section = Section() // 名前なしセクションを作成
            left +++ section
            section +++ right
            return left
        }
        
    }
    
    
    static func  += (left : inout Page, section: Section) {
        left.append(section)
    }
}



// Collection of rows
@objc(Section)
class Section:NSObject  {
    private var rows : [Row] = []
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
    
    func append(_ r: Row) {
        rows.append(r)
    }
    
    var count : Int {
        return rows.count
    }
    
    subscript (_ index: Int) -> Row {
        return rows[index]
    }
    
    subscript (_ fieldName: String) -> Control? {
        for r in rows {
            let f = r[fieldName]
            if ( f != nil ) {
                return f
            }
        }
        return nil
    }
    
    @discardableResult
    static func +++ (left: Section, right: Row) -> Section {
        left.append(right)
        return left
    }
    
}

@objc(RowCell)
class RowCell : UICollectionViewCell {
    static let id : String = "SMART-CELL"
    override func prepareForReuse() {
        for f in subviews {
            f.removeFromSuperview()
        }
    }
    
    @discardableResult
    static func <<< (left: inout RowCell, right: Container1) -> RowCell {
        for (control) in right.children {
            left.addSubview(control.view)
        }
        right.configLayout()
        left.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        return left
    }
    
}

@objc(Row)
class Row:NSObject {
    internal var controlDic : [String: Control] = [:]
    
    subscript (_ fieldName:String) -> Control? {
        return controlDic[fieldName]
    }
    
    var count : Int {
        return controlDic.count
    }
    
    @discardableResult
    static func <<< (left: Row, right: Row) -> Row {
        left.controlDic = right.controlDic
        return left
    }
    
    @discardableResult
    static func +++ (left: Row, right: Control) -> Row {
        left.controlDic[right.name] = right
        return left
    }
    
    @discardableResult
    static func +++ (left: Row, right: ()->Control) -> Row {
        let c = right()
        return left+++c
    }
    
}

