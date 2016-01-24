//
//  GameSelectionViewController_swift.swift
//  RunningMan_1.0
//
//  Created by Sirius on 15/12/20.
//  Copyright © 2015年 Sirius. All rights reserved.
//

import UIKit

class GameSelectionViewController_swift: UITableViewController,IObserver {

    @IBOutlet weak var Userlable: UILabel?
    @IBOutlet weak var tableview: UITableView?
    
    var pomelo: PomeloWS?
    
    var list: NSArray?
    var selectedGameID : String?
    
    var gameID : String?
    var gameName : String?
    
    func ONMessageCome(socketMsg:SocketMessage)
    {
        if (socketMsg.Type == LIST_GAME)
        {
            var array = [String]() ;
            if(socketMsg.argumentNumber != 0)
            {
                for gameInfo in socketMsg.argumentList
                {
                    array[array.endIndex+1] = gameInfo as! String;
                }
                
                self.list = array;
                tableview?.reloadData();
            }
        }
        
        if (socketMsg.Type == JOIN_GAME)
        {
            if socketMsg.argumentList[0].isEqual("1")
            {
                let na:NetworkAdapter = NetworkAdapter.InitNetwork() as! NetworkAdapter;
                na.UnsubscribeMessage(JOIN_GAME, instance: self);
                na.UnsubscribeMessage(LIST_GAME, instance: self);
                NSLog("加入游戏成功!");
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : GameWaitingViewController = mainStoryboard.instantiateViewControllerWithIdentifier("GameWaitingView") as! GameWaitingViewController
                vc.SetGameID(selectedGameID);
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "游戏";
        
        let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults();
        let name : String? = userDefault.objectForKey("name") as? String;
        
        Userlable!.text = "你好 " + "\(name)";
        
//        pomelo = PomeloWS.GetPomelo() as! PomeloWS?;
//        if pomelo == nil {
//            pomelo = PomeloWS(delegate: self as! PomeloWSDelegate)
//        }
//        pomelo.connectToHost("127.0.0.1", onPort: 3014, withCallback:{**p in**
//            var params: [NSObject : AnyObject] = ["city": "-1"]
//            pomelo(route: "game.gameHandler.list", andParams: params, andCallback: {(json: [NSObject : AnyObject]) -> Void in
//                var gameInfoList: NSData = (json["games"] as! NSData).dataUsingEncoding(NSUTF8StringEncoding)
//                list = NSJSONSerialization.JSONObjectWithData(gameInfoList, options: kNilOptions, error: nil)
//                self.tableview.reloadData()
//            })
//        })


        
        
        let command = "listgame 1\r\n";
        let sCity = "-1\r\n";
        
        let listGameMessage = command + sCity;
        
        let na:NetworkAdapter = NetworkAdapter.InitNetwork() as! NetworkAdapter;
        na.SubscribeMessage(LIST_GAME, instance: self);
        
        na.sendData(listGameMessage);
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    func insertNewObject(sender: AnyObject) {
//        let item : NSDictionary = NSDictionary(objects:["http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8","http://c.hiphotos.baidu.com/video/pic/item/f703738da977391224eade15fb198618377ae2f2.jpg","新增数据", NSDate.date().description] , forKeys: ["video_img","video_title","video_subTitle","video_url"])
//        listVideos.insertObject(item, atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    //返回节的个数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    //返回某个节中的行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return list!.count
    }
    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier : String = "gamelist"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GameInfoTableViewCell
        
        let row = indexPath.row
        cell.imageView!.image = UIImage(contentsOfFile: "pacManIcon.jpg")
        cell.textLabel!.text = self.list![row] as? String
        return cell;
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        let selectedGame = list![indexPath.row]
//        
//        NSCharacterSet* CharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
//        NSArray *GameInfoArray =[selectedGame componentsSeparatedByCharactersInSet:CharacterSet];
//        
//        NSString * command = @"joingame 1\r\n";
//        NSString * arg = [NSString stringWithFormat:@"%@\r\n", [GameInfoArray objectAtIndex:0]];
//        
//        selectedGameID = [NSString stringWithString:arg];
//        
//        
//        NSString * msg = [NSString stringWithFormat:@"%@%@",command, arg];
//        
//        NetworkAdapter *na = [NetworkAdapter InitNetwork];
//        [na SubscribeMessage:JOIN_GAME Instance:self];
//        
//        [na sendData:msg];
        
    }
    
    // 支持单元格编辑功能
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            listVideos.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//        if fromIndexPath != toIndexPath{
//            let object: AnyObject = listVideos.objectAtIndex(fromIndexPath.row)
//            listVideos.removeObjectAtIndex(fromIndexPath.row)
//            if toIndexPath.row > self.listVideos.count{
//                self.listVideos.addObject(object)
//            }else{
//                self.listVideos.insertObject(object, atIndex: toIndexPath.row)
//            }
//        }
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    //在编辑状态，可以拖动设置item位置
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    // MARK: - Navigation
    
    //给新进入的界面进行传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object : NSDictionary = listVideos[indexPath.row] as! NSDictionary
//                (segue.destinationViewController as! JieDetailViewController).detailItem = object
//            }
//        }
    }

}
