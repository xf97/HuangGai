/**
 *Submitted for verification at Etherscan.io on 2020-07-21
*/

/*  _______   ______   ___      ___     ______    _______    ______      ______    ___       
 /"     "| /    " \ |"  \    /"  |   /    " \  |   __ "\  /    " \    /    " \  |"  |      
(: ______)// ____  \ \   \  //   |  // ____  \ (. |__) :)// ____  \  // ____  \ ||  |      
 \/    | /  /    ) :)/\\  \/.    | /  /    ) :)|:  ____//  /    ) :)/  /    ) :)|:  |      
 // ___)(: (____/ //|: \.        |(: (____/ // (|  /   (: (____/ //(: (____/ //  \  |___   
(:  (    \        / |.  \    /:  | \        / /|__/ \   \        /  \        /  ( \_|:  \  
 \__/     \"_____/  |___|\__/|___|  \"_____/ (_______)   \"_____/    \"_____/    \_______) 
 
Play now : https://fomopool.com

*/

pragma solidity 0.6.0;

contract FOMOPOOL {
     address public ownerWallet = 0x2fF324915A980c8C82a0062a6B0f724249F3176d;
     address public feesWallet = 0x6eC27978a98AfA20daA6B85B44De4653853a4816;
      uint public currUserID = 0;
      uint public pool1currUserID = 0;
      uint public pool2currUserID = 0;
      uint public pool3currUserID = 0;
      uint public pool4currUserID = 0;
      uint public pool5currUserID = 0;
      uint public pool6currUserID = 0;
      uint public pool7currUserID = 0;
      uint public pool8currUserID = 0;

      uint public pool1activeUserID = 0;
      uint public pool2activeUserID = 0;
      uint public pool3activeUserID = 0;
      uint public pool4activeUserID = 0;
      uint public pool5activeUserID = 0;
      uint public pool6activeUserID = 0;
      uint public pool7activeUserID = 0;
      uint public pool8activeUserID = 0;

      
      uint public unlimited_level_price=0;
     
      struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint referredUsers;
        mapping(uint => uint) levelExpired;
    }
    
     struct PoolUserStruct {
        bool isExist;
        uint id;
        uint payment_received; 
    }
    
     mapping (address => UserStruct) public users;
     mapping (uint => address) public userList;
     
     mapping (address => PoolUserStruct) public pool1users;
     mapping (uint => address) public pool1userList;
     
     mapping (address => PoolUserStruct) public pool2users;
     mapping (uint => address) public pool2userList;
     
     mapping (address => PoolUserStruct) public pool3users;
     mapping (uint => address) public pool3userList;
     
     mapping (address => PoolUserStruct) public pool4users;
     mapping (uint => address) public pool4userList;
     
     mapping (address => PoolUserStruct) public pool5users;
     mapping (uint => address) public pool5userList;
     
     mapping (address => PoolUserStruct) public pool6users;
     mapping (uint => address) public pool6userList;
     
     mapping (address => PoolUserStruct) public pool7users;
     mapping (uint => address) public pool7userList;
     
     mapping (address => PoolUserStruct) public pool8users;
     mapping (uint => address) public pool8userList;
  
     
     mapping(uint => uint) public LEVEL_PRICE;
    
   uint REGESTRATION_FESS=0.05 ether;
   uint pool1_price=0.05 ether;
   uint pool2_price=0.1 ether ;
   uint pool3_price=0.2 ether;
   uint pool4_price=0.5 ether;
   uint pool5_price=1 ether;
   uint pool6_price=2 ether;
   uint pool7_price=5 ether ;
   uint pool8_price=10 ether;
   
   

   
     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
     event regPoolEntry(address indexed _user,uint _level,   uint _time);
     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
   
     UserStruct[] public requests;
     
      constructor() public {
          

        LEVEL_PRICE[1] = 0.01 ether;
        LEVEL_PRICE[2] = 0.005 ether;
        LEVEL_PRICE[3] = 0.0025 ether;
        LEVEL_PRICE[4] = 0.00025 ether;
        unlimited_level_price=0.00025 ether;

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            referredUsers:0
           
        });
        
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;
       
       
        PoolUserStruct memory pooluserStruct;
        
        pool1currUserID++;

        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool1currUserID,
            payment_received:0
        });
       pool1activeUserID=pool1currUserID;
       pool1users[ownerWallet] = pooluserStruct;
       pool1userList[pool1currUserID]=ownerWallet;
      
        
        pool2currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool2currUserID,
            payment_received:0
        });
       pool2activeUserID=pool2currUserID;
       pool2users[ownerWallet] = pooluserStruct;
       pool2userList[pool2currUserID]=ownerWallet;
       
       
        pool3currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool3currUserID,
            payment_received:0
        });
       pool3activeUserID=pool3currUserID;
       pool3users[ownerWallet] = pooluserStruct;
       pool3userList[pool3currUserID]=ownerWallet;
       
       
        pool4currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool4currUserID,
            payment_received:0
        });
       pool4activeUserID=pool4currUserID;
       pool4users[ownerWallet] = pooluserStruct;
       pool4userList[pool4currUserID]=ownerWallet;

        
        pool5currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool5currUserID,
            payment_received:0
        });
       pool5activeUserID=pool5currUserID;
       pool5users[ownerWallet] = pooluserStruct;
       pool5userList[pool5currUserID]=ownerWallet;
       
       
        pool6currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool6currUserID,
            payment_received:0
        });
       pool6activeUserID=pool6currUserID;
       pool6users[ownerWallet] = pooluserStruct;
       pool6userList[pool6currUserID]=ownerWallet;
       
        pool7currUserID++;
        pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool7currUserID,
            payment_received:0
        });
       pool7activeUserID=pool7currUserID;
       pool7users[ownerWallet] = pooluserStruct;
       pool7userList[pool7currUserID]=ownerWallet;

       pool8currUserID++;
       pooluserStruct = PoolUserStruct({
            isExist:true,
            id:pool8currUserID,
            payment_received:0
        });
       pool8activeUserID=pool8currUserID;
       pool8users[ownerWallet] = pooluserStruct;
       pool8userList[pool8currUserID]=ownerWallet;
      
       
      }
     
       function regUser(uint _referrerID) public payable {
       
        require(!users[msg.sender].isExist, "User Exists");
        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
        require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
       
        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: _referrerID,
            referredUsers:0
        });
   
    
       users[msg.sender] = userStruct;
       userList[currUserID]=msg.sender;
       
        users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
        
       payReferral(1,msg.sender);
        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }
    
   
     function payReferral(uint _level, address _user) internal {
        address referer;
       
        referer = userList[users[_user].referrerID];
       
       
         bool sent = false;
       
            uint level_price_local=0;
            if(_level>4){
            level_price_local=unlimited_level_price;
            }
            else{
            level_price_local=LEVEL_PRICE[_level];
            }
            sent = address(uint160(referer)).send(level_price_local);

            if (sent) {
                emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
                if(_level < 100 && users[referer].referrerID >= 1){
                    payReferral(_level+1,referer);
                }
                else
                {
                    sendBalance();
                }
               
            }
       
        if(!sent) {

            payReferral(_level, referer);
        }
     }
   
       function buyPool1() public payable {
           
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool1_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool1Currentuser=pool1userList[pool1activeUserID];
        
        pool1currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool1currUserID,
            payment_received:0
        });
   
       pool1users[msg.sender] = userStruct;
       pool1userList[pool1currUserID]=msg.sender;
       
       if(pool1users[pool1Currentuser].payment_received < 1){
                address(uint160(pool1Currentuser)).send(pool1_price);
                pool1users[pool1Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);

       }
             if(pool1users[pool1Currentuser].payment_received ==1)
                {
                    
                      pool1currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool1currUserID,
                          payment_received:0
                     });
                     
                      pool1users[pool1Currentuser] = userStruct;
                      pool1userList[pool1currUserID]=pool1Currentuser;
                      
                      address pool1Currentuser=pool1userList[pool1activeUserID];
                      address(uint160(pool1Currentuser)).send(pool1_price);
                      emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
                      
                      pool1activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 1, now);
    }
    
    
      function buyPool2() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool2_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool2Currentuser=pool2userList[pool2activeUserID];
        
        pool2currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool2currUserID,
            payment_received:0
        });
   
       pool2users[msg.sender] = userStruct;
       pool2userList[pool2currUserID]=msg.sender;
       
       if(pool2users[pool2Currentuser].payment_received < 1){
                address(uint160(pool2Currentuser)).send(pool2_price);
                pool2users[pool2Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);

       }
             if(pool2users[pool2Currentuser].payment_received ==1)
                {
                    
                      pool2currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool2currUserID,
                          payment_received:0
                     });
                     
                      pool2users[pool2Currentuser] = userStruct;
                      pool2userList[pool2currUserID]=pool2Currentuser;
                      
                      address pool2Currentuser=pool2userList[pool2activeUserID];
                      address(uint160(pool2Currentuser)).send(pool2_price);
                      emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
                      
                      pool2activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 2, now);
    }
    
    
     function buyPool3() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool3_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool3Currentuser=pool3userList[pool3activeUserID];
        
        pool3currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool3currUserID,
            payment_received:0
        });
   
       pool3users[msg.sender] = userStruct;
       pool3userList[pool3currUserID]=msg.sender;
       
       if(pool3users[pool3Currentuser].payment_received < 1){
                address(uint160(pool3Currentuser)).send(pool3_price);
                pool3users[pool3Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);

       }
             if(pool3users[pool3Currentuser].payment_received ==1)
                {
                    
                      pool3currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool3currUserID,
                          payment_received:0
                     });
                     
                      pool3users[pool3Currentuser] = userStruct;
                      pool3userList[pool3currUserID]=pool3Currentuser;
                      
                      address pool3Currentuser=pool3userList[pool3activeUserID];
                      address(uint160(pool3Currentuser)).send(pool3_price);
                      emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
                      
                      pool3activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 3, now);
    }
    
    
    function buyPool4() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool4_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool4Currentuser=pool4userList[pool4activeUserID];
        
        pool4currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool4currUserID,
            payment_received:0
        });
   
       pool4users[msg.sender] = userStruct;
       pool4userList[pool4currUserID]=msg.sender;
       
       if(pool4users[pool4Currentuser].payment_received < 2){
                address(uint160(pool4Currentuser)).send(pool4_price);
                pool4users[pool4Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);

       }
             if(pool4users[pool4Currentuser].payment_received ==2)
                {
                    
                      pool4currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool4currUserID,
                          payment_received:0
                     });
                     
                      pool4users[pool4Currentuser] = userStruct;
                      pool4userList[pool4currUserID]=pool4Currentuser;
                      
                      address pool4Currentuser=pool4userList[pool4activeUserID];
                      address(uint160(pool4Currentuser)).send(pool4_price);
                      emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
                      
                      pool4activeUserID+=1;
                
                }
            
       emit regPoolEntry(msg.sender, 4, now);
    }
    
    
    
    function buyPool5() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool5_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool5Currentuser=pool5userList[pool5activeUserID];
        
        pool5currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool5currUserID,
            payment_received:0
        });
   
       pool5users[msg.sender] = userStruct;
       pool5userList[pool5currUserID]=msg.sender;
       
       if(pool5users[pool5Currentuser].payment_received < 2){
                address(uint160(pool5Currentuser)).send(pool5_price);
                pool5users[pool5Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);

       }
             if(pool5users[pool5Currentuser].payment_received ==2)
                {
                    
                      pool5currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool5currUserID,
                          payment_received:0
                     });
                     
                      pool5users[pool5Currentuser] = userStruct;
                      pool5userList[pool5currUserID]=pool5Currentuser;
                      
                      address pool5Currentuser=pool5userList[pool5activeUserID];
                      address(uint160(pool5Currentuser)).send(pool5_price);
                      emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
                      
                      pool5activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 5, now);
    }
    
    function buyPool6() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool6_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool6Currentuser=pool6userList[pool6activeUserID];
        
        pool6currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool6currUserID,
            payment_received:0
        });
   
       pool6users[msg.sender] = userStruct;
       pool6userList[pool6currUserID]=msg.sender;
      
       if(pool6users[pool6Currentuser].payment_received < 2){
                address(uint160(pool6Currentuser)).send(pool6_price);
                pool6users[pool6Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);

       }
             if(pool6users[pool6Currentuser].payment_received ==2)
                {
                    
                      pool6currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool6currUserID,
                          payment_received:0
                     });
                     
                      pool6users[pool6Currentuser] = userStruct;
                      pool6userList[pool6currUserID]=pool6Currentuser;
                     
                      address pool6Currentuser=pool6userList[pool6activeUserID];
                      address(uint160(pool6Currentuser)).send(pool6_price);
                      emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
                      
                      pool6activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 6, now);
    }
    
    function buyPool7() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool7_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool7Currentuser=pool7userList[pool7activeUserID];
        
        pool7currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool7currUserID,
            payment_received:0
        });
   
       pool7users[msg.sender] = userStruct;
       pool7userList[pool7currUserID]=msg.sender;
       
       if(pool7users[pool7Currentuser].payment_received < 2){
                address(uint160(pool7Currentuser)).send(pool7_price);
                pool7users[pool7Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);

       }
             if(pool7users[pool7Currentuser].payment_received ==2)
                {
                    
                      pool7currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool7currUserID,
                          payment_received:0
                     });
                     
                      pool7users[pool7Currentuser] = userStruct;
                      pool7userList[pool7currUserID]=pool7Currentuser;
                      
                      address pool7Currentuser=pool7userList[pool7activeUserID];
                      address(uint160(pool7Currentuser)).send(pool7_price);
                      emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
                      
                      pool7activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 7, now);
    }
    
    
    function buyPool8() public payable {
       require(users[msg.sender].isExist, "User Not Registered");
       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
       require(msg.value == pool8_price, 'Incorrect Value');
        
       
        PoolUserStruct memory userStruct;
        address pool8Currentuser=pool8userList[pool8activeUserID];
        
        pool8currUserID++;

        userStruct = PoolUserStruct({
            isExist:true,
            id:pool8currUserID,
            payment_received:0
        });
   
       pool8users[msg.sender] = userStruct;
       pool8userList[pool8currUserID]=msg.sender;
       
       if(pool8users[pool8Currentuser].payment_received < 2){
                address(uint160(pool8Currentuser)).send(pool8_price);
                pool8users[pool8Currentuser].payment_received+=1;
                emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);

       }
             if(pool8users[pool8Currentuser].payment_received ==2)
                {
                    
                      pool8currUserID++;

                      userStruct = PoolUserStruct({
                          isExist:true,
                          id:pool8currUserID,
                          payment_received:0
                     });
                     
                      pool8users[pool8Currentuser] = userStruct;
                      pool8userList[pool8currUserID]=pool8Currentuser;
                      
                      address pool8Currentuser=pool8userList[pool8activeUserID];
                      address(uint160(pool8Currentuser)).send(pool8_price);
                      emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
                      
                      pool8activeUserID+=1;
                    
                }
            
       emit regPoolEntry(msg.sender, 8, now);
    }

    
    function getEthBalance() public view returns(uint) {
    return address(this).balance;
    }
    
    function sendBalance() private
    {
         if (!address(uint160(feesWallet)).send(getEthBalance()))
         {
             
         }
    }
   
   
}