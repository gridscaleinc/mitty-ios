import UIKit
import PureLayout


@objc(EventViewController)
class EventViewController: UIViewController {
    
    var images = ["event1", "event6", "event4","event10.jpeg","event5", "event9.jpeg"]
    // MARK: - Properties
    var events: [Event]
    
    // MARK: - View Elements
    let searchBar: UISearchBar
    let titleView : UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = ""
        return l
    } ()
    
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
        self.searchBar.placeholder = "Fun for life!"
        
        self.navigationItem.title = "島探"
        
        configureNavigationBar()
//        let uiimage = UIImageView()
//        uiimage.image = UIImage(named: "event1")
//        uiimage.frame = self.view.frame
//        self.view.addSubview(uiimage)
        addSubviews()
        addConstraints()
        configureSubviews()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        searchBarSearchButtonClicked(searchBar)
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        self.navigationItem.titleView = searchBar
    }
    
    private func addSubviews() {
        view.addSubview(titleView)
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
        titleView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        collectionView.autoPinEdge(.top, to: .bottom, of: titleView)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
}


// MARK: - UISearchBarDelegate
extension EventViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITableViewDataSource
extension EventViewController: UICollectionViewDataSource {
   
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
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EventViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)

            return cell
        }
        return EventCell()
    }
    
    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print (handler.view?.description ?? "")
        let eventViewController = EventDetailViewController(event: ((handler.view) as! EventCell).event!)
        self.navigationItem.title = "..."
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(eventViewController, animated: true)
    }
}

extension EventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let e = events[indexPath.row]
        // TODO
        let image = UIImage(named: images[Int(e.id!)])
        let ratio = image == nil ? 1: (image?.size.height)!/(image?.size.width)!
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) ) 
        let cellSize: CGSize = CGSize( width: width, height:width * ratio + 30 )
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
