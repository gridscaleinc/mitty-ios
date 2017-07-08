import UIKit
import PureLayout
import Starscream
import SwiftyJSON

enum MeetingStatus {
    case initializing
    case talking
}

@objc(TalkListViewController)
class TalkListViewController: UIViewController ,WebSocketDelegate {
    var pingPongTimer : Timer? = nil
    
    var socket : WebSocket = {
        let ws = WebSocket(url: URL(string: "ws://dev.mitty.co/ws/abc")!, protocols: ["chat", "superchat"])
        ws.headers["X-Mitty-AccessToken"] = ApplicationContext.userSession.accessToken
        return ws
    } ()
    
    var status = MeetingStatus.initializing
    
    var disconnected = true
    
    var meeting : MeetingInfo!
    
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
    init(meeting: MeetingInfo) {
        
        self.meeting = meeting
        
        self.topLabel = UILabel.newAutoLayout()
        self.topLabel.text = ""
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        talkInputField = StyledTextField.newAutoLayout()
        talkInputField.placeholder = "input message here"
        talkInputField.layer.borderColor = UIColor.orange.cgColor
        
        talkSendButton = UIButton.newAutoLayout()
        talkSendButton.setTitle("送信", for: .normal)
        talkSendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        talkSendButton.backgroundColor = MittyColor.healthyGreen
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
        self.navigationItem.title = "# " + (meeting.name)
        
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
        
        MeetingService.instance.getLatestConversation(meeting.id, callback: {
            talks in
            self.talkingList.append(contentsOf: talks)
            self.collectionView.reloadData()
            self.status = .talking
        }, onError: {
            error in
            
        })
        
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
            "messageType" : "Conversation",
            "topic" : "Conversation:(\(meeting.id))",
            "command" : "talk",
            "conversation" : [
                "meetingId" : NSNumber(value: meeting.id),
                "speaking" : talkInputField.text ?? "No message",
                "speakTime" : Date().iso8601UTC
                ]
        ]
        
        let js = JSON(message).rawString()
        socket.write(string: js!)
        talkInputField.text = ""
        print(js ?? "")
        
    }
    
    // MessageType string `json:"messageType"`
    // Topic string `json:"topic"`
    // Command string `json:"command"`
    func subscribe() {
        let message : [String:Any] = [
            "messageType" : "Conversation",
            "topic" : "Conversation:(\(meeting.id))",
            "command" : "subscribe"
        ]
        
        let js = JSON(message).rawString()
        
        socket.write(string: js!)
        
    }
    
    // MARK: - View Setup
    private func configureNavigationBar() {
        
        navLabel.autoSetDimension(.height, toSize:15)
        navLabel.autoSetDimension(.width, toSize: 10)
        
        let cameraItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target:self, action:#selector(camera))
        let searchItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target:self, action:#selector(search))
        
        let rightItems = [cameraItem, searchItem]
        
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
    }
    
    func camera() {
        
    }
    
    func search() {
        
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
        subscribe()
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
        
        let conversationJs = js["conversation"]
        tk1.meetingId = conversationJs["meetingId"].int64!
        tk1.speakerId = conversationJs["speakerId"].int64!
        tk1.speakTime = conversationJs["speakTime"].stringValue.utc2Date()
        tk1.speaking = conversationJs["speaking"].rawString()!
        
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
        return TalkingCell()
    }
    
}

extension TalkListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let talk = talkingList[indexPath.row]
        
        let screenSize:CGSize = UIScreen.main.bounds.size
        let width = ( screenSize.width - (10 * 3) )
        var cellSize: CGSize = CGSize( width: width, height:70 )
        
        cellSize.height = heightForView(text: talk.speaking, font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), width: width - 40) + 50
        
        return cellSize
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10)
    }
}
