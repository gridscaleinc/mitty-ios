import UIKit
import PureLayout


@objc(HomeViewController)
class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    var events: [Event]
    
    // MARK: - View Elements
    let searchBar: UISearchBar
    let collectionView: UICollectionView
    
    // MARK: - Initializers
    init() {
        events = [Event]()
        self.searchBar = UISearchBar.newAutoLayout()
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.searchBar.becomeFirstResponder()
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {}
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func configureSubviews() {
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EventCell.self, forCellWithReuseIdentifier:EventCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        searchBar.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        searchBar.autoPinEdge(toSuperviewEdge: .left)
        searchBar.autoPinEdge(toSuperviewEdge: .right)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: searchBar)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
}


// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        events.removeAll()
        
        if searchBar.text != nil || (searchBar.text?.lengthOfBytes(using: String.Encoding.utf8 ))! >= 0 {
            events.append(buildEvent(1))
            events.append(buildEvent(2))
            events.append(buildEvent(3))
            events.append(buildEvent(4))
            events.append(buildEvent(5))
        }
        
        collectionView.reloadData()

    }
}

func buildEvent(_ n:Int) ->Event! {
    
    let imagenames: [String] = ["event1","event2","event3","event4","event5","event6"]
    
    let a = Event()
    
    a.eventId = "id" + String(n)
    a.title = "title" + String(n)
    a.price  = 10 * n
    a.imageUrl = imagenames[n-1]
    a.startDate = "2016-09-09"
    a.endDate = "2016-10-10"
    a.startTime = "12:30"
    a.endTime = "16:30"
    
    a.likes = 10+n
    
    a.endTime = "12:34:56"
    
    return a;
}

// MARK: - UITableViewDataSource
extension HomeViewController: UICollectionViewDataSource {
   
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.id, for: indexPath ) as? EventCell
        {
            cell.configureView(event: events[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
            let tapGestureRecognizer = CellTagHandler(cell: cell, target:self, action:#selector(HomeViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)

            return cell
        }
        return EventCell()
    }
    
    func cellTapped(handler: CellTagHandler) {
        
        print (handler.cell.event)
        let ev = EventDetailViewController(event: handler.cell.event!)
        self.navigationItem.title = "..."
        self.navigationController?.pushViewController(ev, animated: true)
    }
}

class CellTagHandler : UITapGestureRecognizer {
    var cell : EventCell
    
    init(cell: EventCell, target:Any?, action: Selector? ) {
        self.cell = cell
        super.init(target:target, action:action)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) ) / 2
        let cellSize: CGSize = CGSize( width: width, height:width * 1.2 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
