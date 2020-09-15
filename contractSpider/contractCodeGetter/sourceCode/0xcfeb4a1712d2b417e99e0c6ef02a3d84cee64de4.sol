/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

/**
*$$$$$$$$\ $$\     $$\       $$\      $$\                                          $$\     
*$$  _____|$$ |    $$ |      $$$\    $$$ |                                         $$ |    
*$$ |    $$$$$$\   $$$$$$$\  $$$$\  $$$$ | $$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\ $$$$$$\   
*$$$$$\  \_$$  _|  $$  __$$\ $$\$$\$$ $$ | \____$$\ $$  __$$\ $$  __$$\ $$  __$$\\_$$  _|  
*$$  __|   $$ |    $$ |  $$ |$$ \$$$  $$ | $$$$$$$ |$$ /  $$ |$$ |  $$ |$$$$$$$$ | $$ |    
*$$ |      $$ |$$\ $$ |  $$ |$$ |\$  /$$ |$$  __$$ |$$ |  $$ |$$ |  $$ |$$   ____| $$ |$$\ 
*$$$$$$$$\ \$$$$  |$$ |  $$ |$$ | \_/ $$ |\$$$$$$$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$\  \$$$$  |
*\________| \____/ \__|  \__|\__|     \__| \_______| \____$$ |\__|  \__| \_______|  \____/ 
*                                                   $$\   $$ |                             
*                                                  \$$$$$$  |                             
*                                                   \______/    
*
*
* EthMagnet is a highly-evolved and upgraded version of Decentralized Matrix smart contract.
* It has been conceptualized and implemented by some of the pioneers of blockchain technology. As you will notice in the code below, it utilizes the full-power of the underlying Ethereum smart-contract capability to deliver a transparent implementation of the decentralized matrix over blockchain. The biggest focus in here is to turbocharge your profitability in a secure and sustainable manner. EthMagnet is the only platform out there which ensures that:
* - You get an opportunity to participate in the most advanced and powerful platform that is miles ahead of any other option.
* - You get the most profitability out of the efforts  that you make towards building a life of your dreams.
*   We're pleased to unveil the next leap in the evolution of Decentralized Matrix below:
**/
                           
pragma solidity >=0.4.23 <0.6.0;

contract SmartEthMatrix {
    
    struct Member {
        uint id;
        address referrer;
        uint partnersCount;
        
        mapping(uint8 => bool) activeM3Levels;
        mapping(uint8 => bool) activeM4Levels;
        
        mapping(uint8 => M3) m3Matrix;
        mapping(uint8 => M4) m4Matrix;
    }
    
    struct M3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }
    
    struct M4 {
        address currentReferrer;
        address[] firstLevelReferrals;
        address[] secondLevelReferrals;
        bool blocked;
        uint reinvestCount;

        address closedPart;
    }

    uint8 public constant TOTAL_LEVEL = 12;
    
    mapping(address => Member) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;
    mapping(address => uint) public balances; 

    uint public lastMemberId = 2;
    address public owner;
    
    mapping(uint8 => uint) public levelPrice;
    
    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
    event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    
    
    constructor(address ownerAddress) public {
        levelPrice[1] = 0.025 ether;
        for (uint8 i = 2; i <= TOTAL_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
       
        
        owner = ownerAddress;
        
        
        Member memory user = Member({
            id: 1,
            referrer: address(0),
            partnersCount: uint(0)
            
        });
         
        users[ownerAddress] = user;
        
        idToAddress[1] = ownerAddress;
        
        for (uint8 i = 1; i <= TOTAL_LEVEL; i++) {
            users[ownerAddress].activeM3Levels[i] = true;
            users[ownerAddress].activeM4Levels[i] = true;
        }
        
        userIds[1] = ownerAddress;
        
        
        
    }
    
    function() external payable {
        if(msg.data.length == 0) {
            return registration(msg.sender, owner);
        }
        
        registration(msg.sender, bytesToAddress(msg.data));
    }

    function registrationMember(address referrerAddress) external payable {
        registration(msg.sender, referrerAddress);
    }
    function registrationGroup(address referrerAddress,address[] memory addr ) public {
        require(msg.sender==owner, "invalid caller");
        for (uint8 i = 0; i < addr.length; i++) {
            registrationAirdrop(addr[i], referrerAddress);
        }
    }
    
    function buyNextLevel(uint8 matrix, uint8 level) external payable {
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(matrix == 1 || matrix == 2, "invalid matrix");
        require(msg.value == levelPrice[level], "invalid price");
        require(level > 1 && level <= TOTAL_LEVEL, "invalid level");

        if (matrix == 1) {
            require(!users[msg.sender].activeM3Levels[level], "level already activated");

            if (users[msg.sender].m3Matrix[level-1].blocked) {
                users[msg.sender].m3Matrix[level-1].blocked = false;
            }
    
            address freeM3Referrer = findFreeM3Referrer(msg.sender, level);
            users[msg.sender].m3Matrix[level].currentReferrer = freeM3Referrer;
            users[msg.sender].activeM3Levels[level] = true;
            updateM3Referrer(msg.sender, freeM3Referrer, level);
            
            emit Upgrade(msg.sender, freeM3Referrer, 1, level);

        } else {
            require(!users[msg.sender].activeM4Levels[level], "level already activated"); 

            if (users[msg.sender].m4Matrix[level-1].blocked) {
                users[msg.sender].m4Matrix[level-1].blocked = false;
            }

            address freeM4Referrer = findFreeM4Referrer(msg.sender, level);
            
            users[msg.sender].activeM4Levels[level] = true;
            updateM4Referrer(msg.sender, freeM4Referrer, level);
            
            emit Upgrade(msg.sender, freeM4Referrer, 2, level);
        }
    }  
    
     
    function registration(address userAddress, address referrerAddress) private  {
        
        require(msg.value == 0.05 ether, "registration cost is 0.05");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        Member memory user = Member({
            id: lastMemberId,
            referrer: referrerAddress,
            partnersCount: 0
        });
        
        users[userAddress] = user;
        idToAddress[lastMemberId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        users[userAddress].activeM3Levels[1] = true; 
        users[userAddress].activeM4Levels[1] = true;
        
        
        userIds[lastMemberId] = userAddress;
        lastMemberId++;
        
        users[referrerAddress].partnersCount++;

        address freeM3Referrer = findFreeM3Referrer(userAddress, 1);
        users[userAddress].m3Matrix[1].currentReferrer = freeM3Referrer;
        updateM3Referrer(userAddress, freeM3Referrer, 1);

        updateM4Referrer(userAddress, findFreeM4Referrer(userAddress, 1), 1);
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id); 
        
    }
    
    function updateM3Referrer(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].m3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].m3Matrix[level].referrals.length < 3) {
            emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].m3Matrix[level].referrals.length));
            return sendETHDividends(referrerAddress, userAddress, 1, level);
        }
        
        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
        //close matrix
        users[referrerAddress].m3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeM3Levels[level+1] && level != TOTAL_LEVEL) {
            users[referrerAddress].m3Matrix[level].blocked = true;
        }

        //create new one by recursion
        if (referrerAddress != owner) {
            //check referrer active level
            address freeReferrerAddress = findFreeM3Referrer(referrerAddress, level);
            if (users[referrerAddress].m3Matrix[level].currentReferrer != freeReferrerAddress) {
                users[referrerAddress].m3Matrix[level].currentReferrer = freeReferrerAddress;
            }
            
            users[referrerAddress].m3Matrix[level].reinvestCount++;
            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
            updateM3Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            sendETHDividends(owner, userAddress, 1, level);
            users[owner].m3Matrix[level].reinvestCount++;
            emit Reinvest(owner, address(0), userAddress, 1, level);
        }
    }

    function updateM4Referrer(address userAddress, address referrerAddress, uint8 level) private {
        require(users[referrerAddress].activeM4Levels[level], "500. Referrer level is inactive");
        
        if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length < 2) {
            users[referrerAddress].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].m4Matrix[level].firstLevelReferrals.length));
            
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = referrerAddress;

            if (referrerAddress == owner) {
                return sendETHDividends(referrerAddress, userAddress, 2, level);
            }
            
            address ref = users[referrerAddress].m4Matrix[level].currentReferrer;            
            users[ref].m4Matrix[level].secondLevelReferrals.push(userAddress); 
            
            uint len = users[ref].m4Matrix[level].firstLevelReferrals.length;
            
            if ((len == 2) && 
                (users[ref].m4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
                (users[ref].m4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }  else if ((len == 1 || len == 2) &&
                    users[ref].m4Matrix[level].firstLevelReferrals[0] == referrerAddress) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 3);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 4);
                }
            } else if (len == 2 && users[ref].m4Matrix[level].firstLevelReferrals[1] == referrerAddress) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }

            return updateM4ReferrerSecondLevel(userAddress, ref, level);
        }
        
        users[referrerAddress].m4Matrix[level].secondLevelReferrals.push(userAddress);

        if (users[referrerAddress].m4Matrix[level].closedPart != address(0)) {
            if ((users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]) &&
                (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] ==
                users[referrerAddress].m4Matrix[level].closedPart)) {

                updateM4(userAddress, referrerAddress, level, true);
                return updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].m4Matrix[level].closedPart) {
                updateM4(userAddress, referrerAddress, level, true);
                return updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else {
                updateM4(userAddress, referrerAddress, level, false);
                return updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
            }
        }

        if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[1] == userAddress) {
            updateM4(userAddress, referrerAddress, level, false);
            return updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
        } else if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == userAddress) {
            updateM4(userAddress, referrerAddress, level, true);
            return updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
        }
        
        if (users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length <= 
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length) {
            updateM4(userAddress, referrerAddress, level, false);
        } else {
            updateM4(userAddress, referrerAddress, level, true);
        }
        
        updateM4ReferrerSecondLevel(userAddress, referrerAddress, level);
    }

    function updateM4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
        if (!x2) {
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].m4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = users[referrerAddress].m4Matrix[level].firstLevelReferrals[0];
        } else {
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].m4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = users[referrerAddress].m4Matrix[level].firstLevelReferrals[1];
        }
    }
    
    function updateM4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
        if (users[referrerAddress].m4Matrix[level].secondLevelReferrals.length < 4) {
            return sendETHDividends(referrerAddress, userAddress, 2, level);
        }
        
        address[] memory m4 = users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].firstLevelReferrals;
        
        if (m4.length == 2) { 
		if (m4[0] == referrerAddress || m4[1] == referrerAddress) {
                	users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].closedPart = referrerAddress;
            	} else if (m4.length == 1) {
                	if (m4[0] == referrerAddress) {
                    		users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].closedPart = referrerAddress;
                	}
            	}
        }
        
        users[referrerAddress].m4Matrix[level].firstLevelReferrals = new address[](0);
        users[referrerAddress].m4Matrix[level].secondLevelReferrals = new address[](0);
        users[referrerAddress].m4Matrix[level].closedPart = address(0);

        if (!users[referrerAddress].activeM4Levels[level+1] && level != TOTAL_LEVEL) {
            users[referrerAddress].m4Matrix[level].blocked = true;
        }

        users[referrerAddress].m4Matrix[level].reinvestCount++;
        
        if (referrerAddress != owner) {
            address freeReferrerAddress = findFreeM4Referrer(referrerAddress, level);

            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
            updateM4Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            emit Reinvest(owner, address(0), userAddress, 2, level);
            sendETHDividends(owner, userAddress, 2, level);
        }
    }
    
    function findFreeM3Referrer(address userAddress, uint8 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeM3Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }
    
    function findFreeM4Referrer(address userAddress, uint8 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeM4Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }
        
    function usersActiveM3Levels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeM3Levels[level];
    }

    function usersActiveM4Levels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeM4Levels[level];
    }

    function usersM3MatrixData(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
        return (users[userAddress].m3Matrix[level].currentReferrer,
                users[userAddress].m3Matrix[level].referrals,
                users[userAddress].m3Matrix[level].blocked);
    }

    function usersM4MatrixData(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
        return (users[userAddress].m4Matrix[level].currentReferrer,
                users[userAddress].m4Matrix[level].firstLevelReferrals,
                users[userAddress].m4Matrix[level].secondLevelReferrals,
                users[userAddress].m4Matrix[level].blocked,
                users[userAddress].m4Matrix[level].closedPart);
    }
    
    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }


    function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
        address receiver = userAddress;
        bool isExtraDividends;
        if (matrix == 1) {
            while (true) {
                if (users[receiver].m3Matrix[level].blocked) {
                    emit MissedEthReceive(receiver, _from, 1, level);
                    isExtraDividends = true;
                    receiver = users[receiver].m3Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        } else {
            while (true) {
                if (users[receiver].m4Matrix[level].blocked) {
                    emit MissedEthReceive(receiver, _from, 2, level);
                    isExtraDividends = true;
                    receiver = users[receiver].m4Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        }
    }

    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);

        if (!address(uint160(receiver)).send(levelPrice[level])) {
            return address(uint160(receiver)).transfer(address(this).balance);
        }
        
        if (isExtraDividends) {
            emit SentExtraEthDividends(_from, receiver, matrix, level);
        }
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    function registrationAirdrop(address userAddress, address referrerAddress) private {
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        Member memory user = Member({
            id: lastMemberId,
            referrer: referrerAddress,
            partnersCount: 0
        });
        
        users[userAddress] = user;
        idToAddress[lastMemberId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        users[userAddress].activeM3Levels[1] = true; 
        users[userAddress].activeM4Levels[1] = true;
        
        
        userIds[lastMemberId] = userAddress;
        lastMemberId++;
        
        users[referrerAddress].partnersCount++;

        address freeM3Referrer = referrerAddress;
        users[userAddress].m3Matrix[1].currentReferrer = freeM3Referrer;
        updateM3Referrer(userAddress, freeM3Referrer, 1);
        updateM4Referrer(userAddress, referrerAddress, 1);      
        
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
    
    function updateM3ReferrerAirdrop(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].m3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].m3Matrix[level].referrals.length < 3) {
            emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].m3Matrix[level].referrals.length));
            return;
        }
        
        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
        //close matrix
        users[referrerAddress].m3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeM3Levels[level+1] && level != TOTAL_LEVEL) {
            users[referrerAddress].m3Matrix[level].blocked = true;
        }

       
        users[owner].m3Matrix[level].reinvestCount++;
        emit Reinvest(owner, address(0), userAddress, 1, level);
        
        
        
    }
    
    function updateM4ReferrerAirdrop(address userAddress, address referrerAddress, uint8 level) private {
        require(users[referrerAddress].activeM4Levels[level], "500. Referrer level is inactive");
        
        if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length < 2) {
            users[referrerAddress].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].m4Matrix[level].firstLevelReferrals.length));
            
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = referrerAddress;

            if (referrerAddress == owner) {
                return;                
            }
            
            address ref = users[referrerAddress].m4Matrix[level].currentReferrer;            
            users[ref].m4Matrix[level].secondLevelReferrals.push(userAddress); 
            
            uint len = users[ref].m4Matrix[level].firstLevelReferrals.length;
            
            if ((len == 2) && 
                (users[ref].m4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
                (users[ref].m4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }  else if ((len == 1 || len == 2) &&
                    users[ref].m4Matrix[level].firstLevelReferrals[0] == referrerAddress) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 3);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 4);
                }
            } else if (len == 2 && users[ref].m4Matrix[level].firstLevelReferrals[1] == referrerAddress) {
                if (users[referrerAddress].m4Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }

            return updateM4ReferrerSecondLevelAirdrop(userAddress, ref, level);
        }
        
        users[referrerAddress].m4Matrix[level].secondLevelReferrals.push(userAddress);

        if (users[referrerAddress].m4Matrix[level].closedPart != address(0)) {
            if ((users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]) &&
                (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] ==
                users[referrerAddress].m4Matrix[level].closedPart)) {

                updateM4Airdrop(userAddress, referrerAddress, level, true);
                return updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
            } else if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].m4Matrix[level].closedPart) {
                updateM4Airdrop(userAddress, referrerAddress, level, true);
                return updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
            } else {
                updateM4Airdrop(userAddress, referrerAddress, level, false);
                return updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
            }
        }

        if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[1] == userAddress) {
            updateM4Airdrop(userAddress, referrerAddress, level, false);
            return updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
        } else if (users[referrerAddress].m4Matrix[level].firstLevelReferrals[0] == userAddress) {
            updateM4Airdrop(userAddress, referrerAddress, level, true);
            return updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
        }
        
        if (users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length <= 
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length) {
            updateM4Airdrop(userAddress, referrerAddress, level, false);
        } else {
            updateM4Airdrop(userAddress, referrerAddress, level, true);
        }
        
        updateM4ReferrerSecondLevelAirdrop(userAddress, referrerAddress, level);
    }

    function updateM4Airdrop(address userAddress, address referrerAddress, uint8 level, bool x2) private {
        if (!x2) {
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].m4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[0]].m4Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = users[referrerAddress].m4Matrix[level].firstLevelReferrals[0];
        } else {
            users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].m4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].m4Matrix[level].firstLevelReferrals[1]].m4Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].m4Matrix[level].currentReferrer = users[referrerAddress].m4Matrix[level].firstLevelReferrals[1];
        }
    }
    
    function updateM4ReferrerSecondLevelAirdrop(address userAddress, address referrerAddress, uint8 level) private {
        if (users[referrerAddress].m4Matrix[level].secondLevelReferrals.length < 4) {
            return ;
        }
        
        address[] memory m4 = users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].firstLevelReferrals;
        
        if (m4.length == 2) {
            if (m4[0] == referrerAddress ||
                m4[1] == referrerAddress) {
                users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].closedPart = referrerAddress;
            } else if (m4.length == 1) {
                if (m4[0] == referrerAddress) {
                    users[users[referrerAddress].m4Matrix[level].currentReferrer].m4Matrix[level].closedPart = referrerAddress;
                }
            }
        }
        
        users[referrerAddress].m4Matrix[level].firstLevelReferrals = new address[](0);
        users[referrerAddress].m4Matrix[level].secondLevelReferrals = new address[](0);
        users[referrerAddress].m4Matrix[level].closedPart = address(0);

        if (!users[referrerAddress].activeM4Levels[level+1] && level != TOTAL_LEVEL) {
            users[referrerAddress].m4Matrix[level].blocked = true;
        }

        users[referrerAddress].m4Matrix[level].reinvestCount++;
        
        if (referrerAddress != owner) {
            address freeReferrerAddress = findFreeM4Referrer(referrerAddress, level);

            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
            updateM4ReferrerAirdrop(referrerAddress, freeReferrerAddress, level);
        } else {
            emit Reinvest(owner, address(0), userAddress, 2, level);
            
        }
    }


}


/**
*
* 
* 
*$$$$$$$$\ $$\     $$\       $$\      $$\                                          $$\     
*$$  _____|$$ |    $$ |      $$$\    $$$ |                                         $$ |    
*$$ |    $$$$$$\   $$$$$$$\  $$$$\  $$$$ | $$$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\ $$$$$$\   
*$$$$$\  \_$$  _|  $$  __$$\ $$\$$\$$ $$ | \____$$\ $$  __$$\ $$  __$$\ $$  __$$\\_$$  _|  
*$$  __|   $$ |    $$ |  $$ |$$ \$$$  $$ | $$$$$$$ |$$ /  $$ |$$ |  $$ |$$$$$$$$ | $$ |    
*$$ |      $$ |$$\ $$ |  $$ |$$ |\$  /$$ |$$  __$$ |$$ |  $$ |$$ |  $$ |$$   ____| $$ |$$\ 
*$$$$$$$$\ \$$$$  |$$ |  $$ |$$ | \_/ $$ |\$$$$$$$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$\  \$$$$  |
*\________| \____/ \__|  \__|\__|     \__| \_______| \____$$ |\__|  \__| \_______|  \____/ 
*                                                   $$\   $$ |                             
*                                                  \$$$$$$  |                             
*                                                   \______/    
*
**/