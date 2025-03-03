//
//  IslandForm.swift
//  mitty
//
//  Created by gridscale on 2017/04/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class IslandPickForm: MQForm, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var searchBarControl: Control = {
        let bar = UISearchBar.newAutoLayout()
        bar.backgroundColor = .white
        bar.layer.borderColor = UIColor.black.cgColor
        bar.layer.borderWidth = 0.5
        bar.layer.cornerRadius = 5
        bar.placeholder = "場所名や住所"
        bar.keyboardType = .default

        let barControl = Control(name: "Search-bar", view: bar)

        return barControl
    }()

    // 名称
    var nameControl: Control = {
        let f = StyledTextField.newAutoLayout()
        f.placeholder = "場所"
        let c = Control(name: "name", view: f)
        return c
    }()

    // icon
    var iconControl: Control = {
        let img = UIImageView.newAutoLayout()
        img.image = UIImage(named: "timesquare")
        let c = Control(name: "icon", view: img)
        return c
    }()

    // id
    var idControl: Control = {
        let l = UILabel.newAutoLayout()
        l.text = "(    )"
        let c = Control(name: "id", view: l)

        return c
    } ()

    // 愛称
    var nickNameControl: Control = {
        let t = StyledTextField.newAutoLayout()
        t.placeholder = "島名"
        let c = Control(name: "nickName", view: t)
        return c
    } ()

    // アドレス
    var addressControl: Control = {
        let t = StyledTextField.newAutoLayout()
        t.placeholder = "住所"
        let c = Control(name: "address", view: t)
        return c
    } ()

    // OK button
    var okButton: Control = {
        let b = MQForm.button(name: "ok-button", title: "OK")
        return b
    } ()

    // 候補場所テーブル
    var nameTable: Control = {
        let searchResultsTableView: UITableView = UITableView.newAutoLayout()
        let c = Control(name: "searchResult", view: searchResultsTableView)
        return c
    } ()

    //　地図
    var mapControl: Control = {
        let map = MKMapView.newAutoLayout()
        let c = Control(name: "map", view: map)
        return c
    } ()



    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    var selectedPlaceMark: CLPlacemark? = nil

    //
    //
    func buildForm(islandInfo: IslandInfo) {
        let section = Section(name: "section").layout {
            s in
            s.upper(withInset: 5).down(withInset: 10).fillHolizon()
        }

        self +++ section

        // 名称
        var row = Row.LeftAligned().layout {
            r in
            r.height(35).fillHolizon(10)
        }

        row +++ searchBarControl.layout { [weak self]
            bar in
            self?.setColor(bar.view as! UISearchBar, .white)
            bar.fillHolizon(20).height(32).verticalCenter()
        }

        section <<< row

        // id 愛称
        row = Row.LeftAligned().layout {
            r in
            r.height(35).fillHolizon(10)
        }

        row +++ nameControl.layout {
            c in
            c.leftMost(withInset: 10).height(35).rightMost(withInset: 60).verticalCenter()
        }

        row +++ iconControl.layout {
            icon in
            icon.width(35).height(35).upMargin(5).verticalCenter()
        }

        section <<< row

        // id 愛称
        row = Row.LeftAligned().layout {
            r in
            r.height(35).fillHolizon(10)
        }

        row +++ idControl.layout {
            l in
            l.leftMost(withInset: 10).height(35).width(100).verticalCenter()
        }

        row +++ nickNameControl.layout {
            n in
            n.height(30).rightMost(withInset: 10).verticalCenter()
        }

        section <<< row

        // 住所
        row = Row.LeftAligned().layout {
            r in
            r.height(35).fillHolizon(10)
        }

        row +++ addressControl.layout {
            l in
            l.rightMost(withInset: 70).height(30).verticalCenter()
        }

        row +++ okButton.layout {
            l in
            l.rightMost(withInset: 2).height(30).verticalCenter()
            l.view.backgroundColor = .gray
        }


        section <<< row

        //
        row = Row.LeftAligned().layout {
            r in
            r.height(180).fillHolizon()
        }

        row +++ nameTable.layout {
            m in
            m.leftMost(withInset: 10).rightMost(withInset: 10).fillVertical()
        }

        section <<< row


        //
        row = Row.LeftAligned().layout {
            r in
            r.height(200).fillHolizon()
        }

        row +++ mapControl.layout {
            m in
            m.leftMost(withInset: 10).rightMost(withInset: 10).fillVertical()
        }

        section <<< row


        searchCompleter.delegate = self

        let searchResultsTableView = nameTable.view as! UITableView

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self


        searchCompleter.delegate = self

        searchCompleter.filterType = .locationsAndQueries

        (searchBarControl.view as! UISearchBar).delegate = self
        searchCompleter.queryFragment = nameText.text ?? ""
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    func setTextDelegate(delegate: UITextFieldDelegate) {
        (nameControl.view as! UITextField).delegate = delegate
    }

    var mapView: MKMapView {
        return mapControl.view as! MKMapView
    }

    var nameText: UITextField {
        return nameControl.view as! UITextField
    }

    var searchBar: UISearchBar {
        return searchBarControl.view as! UISearchBar
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        let searchResultsTableView = nameTable.view as! UITableView
        mapView.removeAnnotations(mapView.annotations)
        searchResultsTableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()

        let comp = searchResults[indexPath.row]
        self.addressControl.textField.text = comp.subtitle
        self.nameText.text = comp.title

        let searchRequest = MKLocalSearchRequest(completion: comp)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            response?.mapItems.forEach { [weak self] item in
                if self?.mapView.annotations != nil {
                    self?.mapView.removeAnnotations((self?.mapView.annotations)!)
                }
                self?.mapView.addAnnotation(item.placemark)
                self?.selectedPlaceMark = item.placemark
            }

            self.mapView.showAnnotations(self.mapView.annotations, animated: true)

        }

    }

    func setColor(_ v: UIView, _ color: UIColor) {
        for view in v.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.white
                }
                if subview is UIImageView {
                    let imageView = subview as! UIImageView
                    imageView.removeFromSuperview()
                }
            }
        }
    }


}
