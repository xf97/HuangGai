/**
 *Submitted for verification at Etherscan.io on 2020-07-22
*/

/**
*
*  HHHHHHHHH     HHHHHHHHHPPPPPPPPPPPPPPPPP        UUUUUUUU     UUUUUUUUPPPPPPPPPPPPPPPPP
*  H:::::::H     H:::::::HP::::::::::::::::P       U::::::U     U::::::UP::::::::::::::::P
*  H:::::::H     H:::::::HP::::::PPPPPP:::::P      U::::::U     U::::::UP::::::PPPPPP:::::P
*  HH::::::H     H::::::HHPP:::::P     P:::::P     UU:::::U     U:::::UUPP:::::P     P:::::P
*    H:::::H     H:::::H    P::::P     P:::::P      U:::::U     U:::::U   P::::P     P:::::P
*    H:::::H     H:::::H    P::::P     P:::::P      U:::::D     D:::::U   P::::P     P:::::P
*    H::::::HHHHH::::::H    P::::PPPPPP:::::P       U:::::D     D:::::U   P::::PPPPPP:::::P
*    H:::::::::::::::::H    P:::::::::::::PP        U:::::D     D:::::U   P:::::::::::::PP
*    H:::::::::::::::::H    P::::PPPPPPPPP          U:::::D     D:::::U   P::::PPPPPPPPP
*    H::::::HHHHH::::::H    P::::P                  U:::::D     D:::::U   P::::P
*    H:::::H     H:::::H    P::::P                  U:::::D     D:::::U   P::::P
*    H:::::H     H:::::H    P::::P                  U::::::U   U::::::U   P::::P
*  HH::::::H     H::::::HHPP::::::PP                U:::::::UUU:::::::U PP::::::PP
*  H:::::::H     H:::::::HP::::::::P                 UU:::::::::::::UU  P::::::::P
*  H:::::::H     H:::::::HP::::::::P                   UU:::::::::UU    P::::::::P
*  HHHHHHHHH     HHHHHHHHHPPPPPPPPPP                     UUUUUUUUU      PPPPPPPPPP
*
*/

pragma solidity >=0.4.24;

contract HPUP {
    struct Matrix {
        uint id;
        address owner;
        uint referrals_cnt;
        mapping(uint => uint) referrals;
        uint matrix_referrer;
        address direct_referrer;
        uint from_hp;
        uint cycles;
    }

    struct User {
        uint id;
        address referrer;
        uint matrices_cnt;
        uint current_matrix;
        uint lastMatrix;
        uint hp_cooldown_time;
        uint hp_cooldown_num;
        uint direct_referrals;
    }

    struct HPLine {
        address owner;
        uint matrix_id;
    }

    mapping(address => User) public users;
    mapping(uint => address) public usersById;
    mapping(uint => mapping(uint => uint)) public usersMatrices;
    mapping(uint => Matrix) public matrices;
    mapping(uint => HPLine) public HP;

    address public owner;
    uint public lastUserId = 1;
    uint public lastHPId = 1;
    uint public lastMatrixId = 1;

    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Transfer(address indexed user, uint indexed userId, uint indexed amount);

    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    constructor(address ownerAddress) public {
        owner = ownerAddress;

        users[owner] = User({
            id: lastUserId,
            referrer: address(0),
            matrices_cnt: 0,
            current_matrix: 0,
            lastMatrix: 0,
            hp_cooldown_time: 0,
            hp_cooldown_num: 0,
            direct_referrals: 0
            });

        usersById[lastUserId] = owner;

        matrices[lastMatrixId] = Matrix({
            id: lastUserId,
            owner: owner,
            referrals_cnt: 0,
            matrix_referrer: 0,
            direct_referrer: address(0),
            from_hp: 0,
            cycles: 0
            });

        usersMatrices[users[owner].id][users[owner].matrices_cnt] = lastMatrixId;
        users[owner].matrices_cnt++;
        users[owner].current_matrix = 0;

        HP[lastHPId] = HPLine({
            matrix_id: lastMatrixId,
            owner: owner
            });

        lastHPId++;
        lastMatrixId++;
        lastUserId++;


    }

    function reg(address referrer) public payable {
        registration(msg.sender, referrer);
    }

    function registration(address userAddress, address referrerAddress) private {
        require(msg.value == 0.15 ether, "registration cost 0.15");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");

        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");

        users[userAddress] = User({
            id: lastUserId,
            referrer: referrerAddress,
            matrices_cnt: 0,
            current_matrix: 0,
            lastMatrix: 0,
            hp_cooldown_time: 0,
            hp_cooldown_num: 0,
            direct_referrals: 0
            });

        usersById[lastUserId] = userAddress;

        lastUserId++;

        users[referrerAddress].direct_referrals++;

        payUser(referrerAddress, 0.025 ether);
        joinHP(lastMatrixId, userAddress);
        fillMatrix(userAddress, referrerAddress, 0);

        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }

    function purchaseHPPosition() public payable {
        require(msg.value == 0.125 ether, "purchase cost 0.125");
        require(isUserExists(msg.sender), "user not exists");
        require(users[msg.sender].matrices_cnt < 150, "max 150 hp allowed");

        if (users[msg.sender].hp_cooldown_time < now - 86400) {
            users[msg.sender].hp_cooldown_time = now;
            users[msg.sender].hp_cooldown_num = 1;
        } else {
            if (users[msg.sender].hp_cooldown_num < 3) {
                users[msg.sender].hp_cooldown_num++;
            } else {
                revert("24h purchase limit");
            }
        }

        joinHP(lastMatrixId, msg.sender);
        fillMatrix(msg.sender, users[msg.sender].referrer, 1);
    }

    function payUser(address user, uint amount) private {
        emit Transfer(user, users[user].id, amount);
        address(uint160(user)).transfer(amount);
    }

    function payHP(address user) private {
        emit Transfer(user, users[user].id, 0.05 ether);
        address(uint160(user)).transfer(0.05 ether);
    }

    function payAdmin(uint amount) private {
        emit Transfer(owner, 0, amount);
        address(uint160(owner)).transfer(amount);
    }

    function joinHP(uint matrixId, address matrixOwner) private {
        HP[lastHPId] = HPLine({
            matrix_id: matrixId,
            owner: matrixOwner
            });
        lastHPId++;

        if (matrices[matrixId].id != 0) {
            matrices[matrixId].cycles++;
        }

        if (lastHPId % 2 == 0) {
            if (lastHPId <= 2) {
                payHP(owner);
            } else {
                payHP(HP[lastHPId / 2 - 1].owner);
                joinHP(HP[lastHPId / 2 - 1].matrix_id, HP[lastHPId / 2 - 1].owner);
                payForMatrix(matrices[HP[lastHPId / 2 - 1].matrix_id].matrix_referrer);
            }
        }
    }

    function payForMatrix(uint slotId) private {
        if (slotId == 0) {
            payAdmin(0.0375 ether);
            return;
        }

        uint level1 = slotId;

        while (users[matrices[level1].owner].direct_referrals < 4) {
            if (level1 == 0) {
                payAdmin(0.0375 ether);
                return;
            }

            level1 = matrices[level1].matrix_referrer;
        }

        payUser(matrices[level1].owner, 0.1 * 0.0375 ether);

        uint level2 = matrices[level1].matrix_referrer;

        while (users[matrices[level2].owner].direct_referrals < 4) {
            if (level2 == 0) {
                payAdmin(0.9 * 0.0375 ether);
                return;
            }

            level2 = matrices[level2].matrix_referrer;
        }

        payUser(matrices[level2].owner, 0.2 * 0.0375 ether);

        uint level3 = matrices[level2].matrix_referrer;

        while (users[matrices[level3].owner].direct_referrals < 4) {
            if (level3 == 0) {
                payAdmin(0.7 * 0.0375 ether);
                return;
            }

            level3 = matrices[level3].matrix_referrer;
        }

        payUser(matrices[level3].owner, 0.3 * 0.0375 ether);

        uint level4 = matrices[level3].matrix_referrer;

        while (users[matrices[level4].owner].direct_referrals < 4) {
            if (level4 == 0) {
                payAdmin(0.4 * 0.0375 ether);
                return;
            }
            level4 = matrices[level4].matrix_referrer;
        }

        payUser(matrices[level4].owner, 0.4 * 0.0375 ether);
    }

    function fillMatrix(address user, address referrer, uint from_hp) private {
        if (referrer == address(0)) {
            referrer = usersById[1];
        }

        uint slotId = findSlot(usersMatrices[users[referrer].id][users[referrer].current_matrix], 1, 4);

        if (slotId == 0) {
            if (users[referrer].current_matrix == users[referrer].matrices_cnt-1) {
                revert("all matrices are full");
            }

            users[referrer].current_matrix++;
            slotId = findSlot(usersMatrices[users[referrer].id][users[referrer].current_matrix], 1, 4);
        }

        payForMatrix(slotId);

        matrices[lastMatrixId] = Matrix({
            id: lastMatrixId,
            owner: user,
            referrals_cnt: 0,
            matrix_referrer: slotId,
            from_hp: from_hp,
            direct_referrer: referrer,
            cycles: 0
            });

        usersMatrices[users[user].id][users[user].matrices_cnt] = lastMatrixId;
        users[user].matrices_cnt++;
        users[user].lastMatrix = lastMatrixId;

        matrices[lastMatrixId].matrix_referrer = slotId;

        lastMatrixId++;

        matrices[slotId].referrals[matrices[slotId].referrals_cnt] = lastMatrixId-1;
        matrices[slotId].referrals_cnt++;
    }

    function findSlot(uint matrix, uint level, uint maxLevel) private returns (uint) {
        if (level > maxLevel) {
            return(0);
        }

        if (matrices[matrix].referrals_cnt < 4) {
            return(matrix);
        }

        uint tmpMaxLevel = level+1;

        while (tmpMaxLevel <= maxLevel) {
            uint i=0;

            do {
                uint slot = findSlot(matrices[matrix].referrals[i], level+1, tmpMaxLevel);
                if (slot != 0) {
                    return(slot);
                }

                i++;
            } while (i<4);

            tmpMaxLevel++;
        }

        return(0);
    }
}