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
        self.searchBar.resignFirstResponder()
        
        self.navigationItem.title = "ホーム"
        
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
    
    /// 子画面からモドたら、tabバーを戻す。
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "ホーム"
    }
    
}


// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        // 非同期方式で処理を呼び出す。
        let queue = OperationQueue()
        let key = searchBar.text
        
        if key != nil || (key?.lengthOfBytes(using: String.Encoding.utf8 ))! >= 0 {
            queue.addOperation() {
                // 非同期処理
                let service = EventService.instance
                let keys = [key]
                
                self.events = service.search(keys: keys as! [String])
                // 非同期処理のコールバック
                OperationQueue.main.addOperation() {
                    self.collectionView.reloadData()
                }
            }
        }
    }
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
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(HomeViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)

            return cell
        }
        return EventCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print (handler.view)
        let eventViewController = EventDetailViewController(event: ((handler.view) as! EventCell).event!)
        self.navigationItem.title = "..."
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(eventViewController, animated: true)
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
        let width = ( screenSize.width - (10 * 3) ) 
        let cellSize: CGSize = CGSize( width: width, height:width * 1.2 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
