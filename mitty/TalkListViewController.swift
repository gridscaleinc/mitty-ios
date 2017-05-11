import UIKit
import PureLayout
import Starscream
import SwiftyJSON


@objc(TalkListViewController)
class TalkListViewController: UIViewController ,WebSocketDelegate {
    var pingPongTimer : Timer? = nil
    
    var socket = WebSocket(url: URL(string: "ws://dev.mitty.co/ws/")!, protocols: ["chat", "superchat"])
    var disconnected = true
    
    var talkingIsLand : Island!
    
    // MARK: - Properties
    var talkingList: [Talk] = {
        var tks = [Talk]()
        
        
        return tks
        
    } ()
    
    let topLabel: UILabel
    
    let panel : UIView = UIView.newAutoLayout()
    var bottomCons : NSLayoutConstraint? = nil
    let talkInputField: StyledTextField
    let talkSendButton: UIButton
    
    
    let collectionView: UICollectionView
    
    let arSwitch : UISwitch = {
        let arswitch = UISwitch.newAutoLayout()
        return arswitch
    } ()
    
    
    let navLabel : UILabel = {
        let l = UILabel.newAutoLayout()
        l.text = "AR"
        l.textColor = UIColor.red
        l.font = l.font.withSize(12.0)
        return l
    } ()
    
    
    
    // MARK: - Initializers
    init(island: Island) {
        
        self.talkingIsLand = island
        
        self.topLabel = UILabel.newAutoLayout()
        self.topLabel.text = ""
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        talkInputField = StyledTextField.newAutoLayout()
        talkInputField.placeholder = "input message here"
        
        talkSendButton = UIButton.newAutoLayout()
        talkSendButton.setTitle("送信", for: .normal)
        talkSendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        talkSendButton.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.topLabel.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.9)        
        self.navigationItem.title = "# " + (talkingIsLand.name ?? "")
        
        talkInputField.layer.borderWidth = 1
        let leftPadding = UIView(frame: CGRect(x:0, y:0, width:15, height:40))
        talkInputField.leftView = leftPadding
        talkInputField.leftViewMode = UITextFieldViewMode.always
        
        configureNavigationBar()
        addSubviews()
        addConstraints()
        configureSubviews()
        
        talkSendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        socket.delegate = self
 
        
        manageKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if disconnected {
            socket.connect()
            super.viewWillAppear(true)
            pingPongTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.sendPing), userInfo: nil, repeats: true)
            
            pingPongTimer?.fire()
        }
    }
    
    func sendPing() {
        if ( !disconnected) {
            socket.write(ping: Data())
        } else {
            socket.connect()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if disconnected {
            return
        }
        socket.disconnect()
    }
    
    func sendMessage(_ sender: UIButton) {
        if (talkInputField.text == "") {
            return
        }
        
        if (disconnected) {
            socket.connect()
            return
        }
        let message : [String:Any] = [
            "email" : "domanthan@gmail.com",
            "username" : "domanthan",
            "message" : talkInputField.text ?? "No message"
        ]
        
        let js = JSON(message).rawString()
        socket.write(string: js!)
        talkInputField.text = ""
        
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
//        let rect = CGRect(x:0, y:0, width:40, height:32)
//        let rightButton = RightButton(frame: rect)
        
        navLabel.autoSetDimension(.height, toSize:15)
        navLabel.autoSetDimension(.width, toSize: 10)
        
//        arSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//        let rightItems = [UIBarButtonItem(customView: navLabel), UIBarButtonItem(customView: arSwitch)]
        let action = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target:self, action:#selector(action1))
        let camera = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target:self, action:#selector(action1))
        let b1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target:self, action:#selector(action1))
        let b2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target:self, action:#selector(action1))
        let b3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target:self, action:#selector(action1))
        
        let rightItems = [action, camera, b1, b2, b3]
        
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
    }
    
    func action1() {
        
    }
    
    private func addSubviews() {
        view.addSubview(topLabel)
        view.addSubview(collectionView)
        
        view.addSubview(panel)
        panel.addSubview(talkInputField)
        panel.addSubview(talkSendButton)
        
    }
    
    private func configureSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TalkingCell.self, forCellWithReuseIdentifier:TalkingCell.id)
        
        collectionView.backgroundColor = UIColor.white
    }
    
    private func addConstraints() {
        topLabel.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        topLabel.autoPinEdge(toSuperviewEdge: .left)
        topLabel.autoPinEdge(toSuperviewEdge: .right)
        topLabel.autoSetDimension(.height, toSize: 2)
        
        
        collectionView.autoPinEdge(.top, to: .bottom, of: topLabel, withOffset: 10)
        
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        bottomCons = collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        
        
        panel.autoPinEdge(.top, to: .bottom, of: collectionView, withOffset: 10)
        panel.autoPinEdge(toSuperviewEdge: .left, withInset: 2)
        panel.autoPinEdge(toSuperviewEdge: .right, withInset: 2)
        panel.autoSetDimension(.height, toSize: 40)
        
        talkInputField.autoPinEdge(toSuperviewEdge: .left)
        talkInputField.autoPinEdge(toSuperviewEdge: .top)
        talkInputField.autoPinEdge(toSuperviewEdge: .bottom)
        talkInputField.autoPinEdge(toSuperviewEdge: .right, withInset: 80)

        talkSendButton.autoPinEdge(.left, to: .right, of: talkInputField, withOffset:2)
        talkSendButton.autoPinEdge(toSuperviewEdge: .top)
        talkSendButton.autoPinEdge(toSuperviewEdge: .bottom)
        talkSendButton.autoPinEdge(toSuperviewEdge: .right)
        
    }
    
    func manageKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc
    func onKeyboardShow(_ notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardHeight = keyboardRect.size.height
        
        if bottomCons != nil {
            bottomCons?.autoRemove()
            bottomCons = collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50 + keyboardHeight)
        }
    }
    
    
    @objc
    func onKeyboardHide(_ notification: NSNotification) {
        if bottomCons != nil {
            bottomCons?.autoRemove()
            bottomCons = collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
        }
        
        self.view.setNeedsUpdateConstraints()
    }
    
    // MARK: Websocket Delegate Methods.
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        disconnected = false
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            pingPongTimer?.invalidate()
        } else {
            print("websocket disconnected, auto reconnecting.")
            socket.connect()
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        let js = JSON.parse(text)
        print(text)
        print(js)
        
        let tk1 = Talk()
        
        let mail = js["email"]
        tk1.familyName = mail.rawString()!
        let userId = js["username"].rawString()!
        
        tk1.mittyId = userId
        tk1.speaking = js["message"].rawString()!
        if userId == "domanthan" {
            tk1.avatarIcon = "pengin"
        } else {
            tk1.avatarIcon = "pengin4"
        }
        
        talkingList.append(tk1)
        if talkingList.count > 100 {
            talkingList.remove(at: 0)
        }
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at:IndexPath(item: talkingList.count-1, section: 0), at: .bottom, animated: true)

    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("Received data: \(data.count)")
    }
    
}

// MARK: - UITableViewDataSource
extension TalkListViewController: UICollectionViewDataSource {
    
    ///
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return talkingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TalkingCell.id, for: indexPath ) as? TalkingCell
        {
            cell.configureView(talk: talkingList[indexPath.row])
            cell.backgroundColor = UIColor(white: 0.99, alpha: 1)
            collectionView.setNeedsLayout()
            return cell
        }
        return IslandCell()
    }
    
}

extension TalkListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let talk = talkingList[indexPath.row]
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) )
        var cellSize: CGSize = CGSize( width: width, height:70 )
        if (talk.height > 0) {
            cellSize.height = CGFloat(talk.height)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
