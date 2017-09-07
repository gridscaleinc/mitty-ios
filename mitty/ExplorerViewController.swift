import UIKit
import PureLayout


@objc(EventViewController)
class EventViewController: MittyViewController {

    var shallWeSearch = false

    // MARK: - Properties
    var events: [EventInfo]

    // MARK: - View Elements
    let searchBar: UISearchBar
    let titleView: UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = ""
        return l
    } ()

    let collectionView: UICollectionView

    // MARK: - Initializers
    init() {
        events = [EventInfo]()
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

        super.autoCloseKeyboard()

        view.backgroundColor = UIColor(white: 0.50, alpha: 1)
//        view.backgroundColor = UIColor.white
        self.searchBar.becomeFirstResponder()
        self.searchBar.resignFirstResponder()
        self.searchBar.placeholder = "Fun for life!"

        self.navigationItem.title = "島探"

        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
    }


    override func viewDidAppear(_ animated: Bool) {
        if shallWeSearch {
            searchBarSearchButtonClicked(searchBar)
            shallWeSearch = false
        }
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
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.id)

//        collectionView.backgroundColor = UIColor.white
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

        let key = searchBar.text
        LoadingProxy.set(self)
        if key != nil || (key?.lengthOfBytes(using: String.Encoding.utf8))! >= 0 {
            let service = EventService.instance
            service.search(keys: key!) {
                events in
                self.events = events
                self.collectionView.reloadData()
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.id, for: indexPath) as? EventCell
            {
            let event = events[indexPath.row]
            if (!event.isDataReady) {
                event.dataReadyHandler = {
                    cell.reloadImages()
                    collectionView.reloadItems(at: [indexPath])
                }
                EventService.instance.loadImages(event)
            }
            cell.configureView(event: event)
            cell.backgroundColor = .white
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
        return EventCell()
    }

    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        print (handler.view?.description ?? "")
        let id = ((handler.view) as! EventCell).event!.id
        handler.view?.isUserInteractionEnabled = false
        EventService.instance.fetch(id: id) {
            event in
            let c = EventDetailViewController(event: event)
            self.navigationController?.pushViewController(c, animated: true)
            self.navigationItem.title = "..."
            self.tabBarController?.tabBar.isHidden = true
            handler.view?.isUserInteractionEnabled = true
        }
    }
}

extension EventViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let event = events[indexPath.row]

        let screenSize: CGSize = UIScreen.main.bounds.size

        if event.coverImage != nil {
            let width = (screenSize.width - (10 * 3))
            let height = event.coverImage!.size.ratio * width
            let cellSize: CGSize = CGSize(width: width, height: height + 190)
            return cellSize
        }

        let width = (screenSize.width - (10 * 3))
        let cellSize: CGSize = CGSize(width: width, height: 190)
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class RequestExplorerViewController: MittyViewController {
    var shallWeSearch = false

    // MARK: - Properties
    var requests: [RequestInfo]

    // MARK: - View Elements
    let searchBar: UISearchBar
    let titleView: UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = ""
        return l
    } ()

    let collectionView: UICollectionView

    // MARK: - Initializers
    init() {
        requests = [RequestInfo]()
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
//        view.backgroundColor = UIColor(white: 0.90, alpha: 1)
//        view.backgroundColor = UIColor.white
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
        if shallWeSearch {
            searchBarSearchButtonClicked(searchBar)
            shallWeSearch = false
        }
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
        collectionView.register(RequestCell.self, forCellWithReuseIdentifier: RequestCell.id)

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
extension RequestExplorerViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false

        let key = searchBar.text
        LoadingProxy.set(self)
        if key != nil || (key?.lengthOfBytes(using: String.Encoding.utf8))! >= 0 {
            let service = RequestService.instance
            service.search(keys: key!) {
                requests in
                self.requests = requests
                self.collectionView.reloadData()
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
extension RequestExplorerViewController: UICollectionViewDataSource {

    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RequestCell.id, for: indexPath) as? RequestCell
            {
            let request = requests[indexPath.row]

            cell.configureView(req: request)
            cell.backgroundColor = .white
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RequestExplorerViewController.cellTapped(handler:)))
            cell.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
        return RequestCell()
    }

    ///
    func cellTapped(handler: UITapGestureRecognizer) {
        handler.view?.isUserInteractionEnabled = false
        let request = ((handler.view) as! RequestCell).request

        let vc = RequestDetailViewController(req: request!)
        self.navigationController?.pushViewController(vc, animated: true)

        handler.view?.isUserInteractionEnabled = true
    }
}

extension RequestExplorerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize: CGSize = UIScreen.main.bounds.size

        let width = (screenSize.width - (10 * 3))
        let cellSize: CGSize = CGSize(width: width, height: 190)
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
