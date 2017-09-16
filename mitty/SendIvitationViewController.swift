//
//  SendInitationViewController.swift
//  mitty
//
//  Created by gridscale on 2017/08/07.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class SendInvitationViewController: MittyViewController {

    let form: MQForm = MQForm.newAutoLayout()

    // MARK: - Properties
    var contactList: [Contactee] = [Contactee]()

    let invitationTitle = MQForm.label(name: "invitation-title", title: "")
    let message = MQForm.textView(name: "invitation-message")

    var event: Event!

    var searchBar: UISearchBar = UISearchBar.newAutoLayout()

    let collectionView: UICollectionView

    var invitees = [Int]()

    let sendButton = MQForm.button(name: "sendbutton", title: "送信")

    // MARK: - Initializers
    init() {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.autoCloseKeyboard()


        self.view.addSubview(form)
        self.view.backgroundColor = .white

        buildForm()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(InviteeCell.self, forCellWithReuseIdentifier: InviteeCell.id)

        collectionView.backgroundColor = UIColor.white

        form.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        form.autoPinEdge(toSuperviewEdge: .left)
        form.autoPinEdge(toSuperviewEdge: .right)
        form.autoPinEdge(toSuperviewEdge: .bottom)

        self.view.setNeedsUpdateConstraints()

        searchBar.delegate = self

        initalContactList()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        form.configLayout()
    }

    func buildForm() {

        let line_height = CGFloat(48)

        form.backgroundColor = UIColor(patternImage: UIImage(named: "beauty2.jpeg")!)
        let anchor = MQForm.label(name: "dummy", title: "").layout {
            a in
            a.height(0).leftMost().rightMost()
        }
        form +++ anchor

        // スクロールViewを作る
        let scroll = UIScrollView.newAutoLayout()
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 900)
        scroll.isScrollEnabled = true
        scroll.flashScrollIndicators()
        scroll.canCancelContentTouches = false
        self.automaticallyAdjustsScrollViewInsets = false

        let scrollContainer = Container(name: "Detail-form", view: scroll).layout() { (container) in
            container.fillParent()
        }

        form +++ scrollContainer

        let detailForm = Section(name: "Content-Form", view: UIView.newAutoLayout())

        scrollContainer +++ detailForm

        seperator(section: detailForm, caption: "招待")

        var row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(60)
        }

        row +++ MQForm.label(name: "event-title", title: "イベント：").layout {
            l in
            l.width(120).height(line_height).verticalCenter()
            l.label.adjustsFontSizeToFitWidth = true
        }

        invitationTitle.label.text = event.title
        row +++ invitationTitle.layout {
            m in
            m.height(line_height).rightMost(withInset: 10).verticalCenter()
        }

        detailForm <<< row


        seperator(section: detailForm, caption: "メッセージ")

        row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(65)
        }

        row +++ message.layout {
            m in
            m.height(60).rightMost(withInset: 10).verticalCenter()
        }

        detailForm <<< row



        seperator(section: detailForm, caption: "招待メンバーリスト")
        row = Row.LeftAligned().layout() {
            r in
            r.fillHolizon(0).height(65)
        }

        row +++ Control(name: "", view: searchBar).layout {
            l in
            l.fillHolizon().height(40).verticalCenter()

        }

        detailForm <<< row


        let listRow = Row.LeftAligned().layout {
            r in
            r.fillHolizon()
        }

        let list = Control(name: "contactList", view: collectionView)
        listRow +++ list.layout {
            l in
            l.fillParent()
        }

        detailForm <<< listRow


        let buttonRow = Row.Intervaled().height(40)
        buttonRow.spacing = 60
        buttonRow +++ sendButton.layout {
            b in
            b.height(40).verticalCenter()
        }.bindEvent(.touchUpInside) { _ in
            self.sendInvitation()
        }

        detailForm <<< buttonRow

        let bottom = Row.LeftAligned().layout {
            b in
            b.fillHolizon().height(20)
        }

        detailForm <<< bottom

        detailForm.layout {
            f in
            f.fillVertical().width(UIScreen.main.bounds.width).bottomAlign(with: bottom)
            f.view.autoSetDimension(.height, toSize: UIScreen.main.bounds.height, relation: .greaterThanOrEqual)
            f.view.backgroundColor = UIColor.white
        }

    }

    func initalContactList () {

        SocialContactService.instance.getContacteeList(onComplete: {
            list in
            self.contactList = list
            self.collectionView.reloadData()
        }, onError: {
            error in
            self.showError(error)
        })
    }

    func sendInvitation () {
        let count = collectionView.numberOfItems(inSection: 0)
        invitees.removeAll()
        
        for i in 0 ... count {
            let index = IndexPath(item: i, section: 0)
            if let cell = collectionView.cellForItem(at: index) as? InviteeCell {
                if cell.selectedStatus {
                    let c = cell.contact
                    self.invitees.append(c!.profile.mittyId)
                }
            }
        }
        
        if invitees.count == 0 {
            return
        }

        InvitationService.instance.sendInvitation("EVENT", id: Int64(event.id)!, message: message.textView.text, invitees: invitees)

        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - UISearchBarDelegate
extension SendInvitationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

        if (searchBar.text == "") {
            return
        }

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

// MARK: - UITableViewDataSource
extension SendInvitationViewController: UICollectionViewDataSource {

    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InviteeCell.id, for: indexPath) as? InviteeCell
            {
            cell.configureView(contact: contactList[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SocialViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)

            return cell
        }
        return InviteeCell()
    }

    ///
    func cellTapped(handler: UITapGestureRecognizer) {

        let inviteeView = (handler.view) as! InviteeCell
        inviteeView.toogleSelected()

    }
}

extension SendInvitationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize: CGSize = UIScreen.main.bounds.size
        let width = (screenSize.width - (10 * 3))
        let cellSize: CGSize = CGSize(width: width, height: 50)
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
