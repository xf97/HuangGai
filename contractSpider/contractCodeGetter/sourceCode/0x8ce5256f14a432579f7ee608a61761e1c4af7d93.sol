/**
 *Submitted for verification at Etherscan.io on 2020-06-24
*/

pragma solidity ^0.4.26;

// ----------------------------------------------------------------------------------------
// Knyazev Sergey Alexandrovich token contract
//
// ########################################################################################
// #########################@@@@#@#@@@@@@@#####@@#@@#######@###############################
// #########################@@@@%%@@%@@@@@@@@@@@@@@@#@####@@##@%###########################
// #######################@@@%%%%%@@@@@@@@@@@@@@@@@#######@@@@%%==%@@######################
// #######################@#@%@%%%%%====++++*++++=%@@######@%@@%%==%@@##@##################
// ######################@@@@%=======+++***********+=%@#######@@@@%%%@%@@##################
// ########################@%===+==++*****************+%@##@@@%@@%%%%%%%@@@@###############
// ######################@%=======++++++*******:::-:::**%@@@@%@@@#@%%%%%%@@%%%#############
// ####################@%==========++++++******:------::*=@@%@@=%%@@%%@%%%%=%@@@@##########
// ##############@####%==========+++++++++++**::-----::::*+%@=%@@%%@@@@%%%%+%%%%%@#########
// ############@@@##@=========+++===+++++++++*:::-:--:::::*+%%%%@@@@@@##@@@%=+=+*%#########
// ###########@@@@#@==========+++==++++++++****:::::::**::++==%%%@@#@@#@@@@%%=%+*+@@@######
// ############@@##%============+==+++++******:::::::*::::*++=%@%%%%%@@@##@%@%%=%%===######
// ##########@@@@@@===========+===++++++*******::::::::::**++=%==@%==%@@@@##@%=+**+%=%@####
// ##############@%================++++========+*:::::::::*+++==@@==%@@@@@@%%%=+++*===%%@##
// ###########@##@%===================%%@@@@@@%%%=+++**::::*++===%@@@@=%%%%%===+****+++%@@@
// ##############@%===%%@@@@@%%=====%%@@@@@###@@%%%%=+**:::**+=%%%%@@=@%%%%=%==+*****+*=@@#
// ##############@%%@@@@@@##@@@%===%@###########@@@%@#%+=+++=%%@#@@#@@%%%@@%+=+++**+++++=@#
// ##############@%%@@%%@@######@@@%########@##@@@@@@%=****+====%%@@@@%@%@@%+%+%%%====+*+@#
// ##############@##@@@##########===%#####@@@@@@@%==%+*+=***::*+=====%%%@%@%*%%%%@%@@%*++%%
// ################@@@##########%=+===@#@@@@@@%==%%++==+********++++%%%%%%%++=+@@@@@%+++=##
// #################@@#@@@###@@%=+**====%%%%=++****+=+++********+++=%+=%@==%%+%#@%%%=+*+=##
// #################@@@%@@@@@@==+++*-*=====++++++++++++++++++*++*+++==%%%%@@%####%====*=###
// ###############@@%%%%%@%==%=++++*:*====%%==++++++++++++++++++*+++=+=%@@@=@##@@@%==+**%@#
// ##############@@====+++==%=======+======@@%=+=+++++++++++++**+*++==%%==+=@#@#@@@===+*%%#
// ##############@@%==%====%@%@@%%%=%@@@%%@@%@@==+++++++++**+++**+*+==+**++=@####@@%=+++=+#
// ##########@@@@@@@%%====%@@%%@#@@@@@@%%%%@%%%%==++*********+*******++++++@####@@%%%+++=+#
// #########@%@@@@@@%%=%%%@@%%%===%%%%====%%%%%=%==++*:***::******+*:**:**@@@####@@%%%==+@#
// ########@@@@@@@@@@%%%%%@@%%====%=====+===+======+*****:::::****::::::**+@%@##@@@@%=++%=#
// #########@@@@@@@%%%%%%@@@@%%============%%%%=====+**::::::*:**:::-:*::*==%@####@%=+*%###
// #########@@@%@@%%@@%%%%%@@@@@########@@@%%%%%%==**++**::::::::*::-::::+**%#@###@%%=+@###
// ##########@@%%@@@@%%%%%%@##%===============%%%%%+********:::::*:--------:*=###@@%=++@###
// ##########@@@@@%%%%%%%%%@#@====%%=%=%=====%%%%===+*+*++***:::::----------*==@@@@=%=%###@
// #########@@@@@@%%%%%%%@@@@%%===%%%%%%%%==%%====++=++*******:*::----------:+=%@%@@@######
// #########@@%@@@%%%%%%@@@@%%%========+===+++++=++*+++****:***::::::-------:*@############
// ########@@@%%%%@%%%@@@%%%%%==+=++*+++==++++=++=++++++****:*::::-------..-*+@@@##########
// ######@@@@@@%%@%%%%@@%%%%====++*++==+=+=+===+++=+*++++*******:-:-------.-*:*#%##########
// ######@@@@@@%%%%%@%@@@@%=++==+++=%====++++*+++==+++*****:*::::----------::*+%%##########
// #######@@@%@%%%@@@@%%%%==+=%=+====%=*+++*++**++++*+*+**::::*:-------------*@%@##########
// #######@@%%%%%%@%@@%%=============++=+=++****++===++***::*::::-------:---:%=@###########
// ######@@@@@%@%@@@@@%%==+=+=%===%+++==++=*****++++==*******:*::-:--.--:::*+=@%###########
// ######@@@@@@@@%@@@%===+++++=+=%=====+++*+****+++++++**+**::*::-:-.--*:*===##############
// ########@@%@%%%%%@%====+=========+====+=*+**+++++*++*****:::::---.-:::*=%###############
// #######@@@@%%%%@%%%========%===%%==+==+*****++**++**+**:*:::::-----*+%@%################
// #########@%%@%%%%%%%====+==========+++++*****+*+***+*:*::::::----.-=%@##################
// #########@@%%%%%%%%%%%=====%%==%====+++**+***+++*******:::::-:--:-+@@%=#################
// ##########@@%%%%%%%%%=%%%%%%%=========+++++++*+++*******::::--:*=@###@=+=%@#############
// ###########@@@@%=%%%%%%%%%%%==%%%======++++++++=+++*****::**===@######@+==%@%%@#########
// ##############@@%%@@@%%%%%%==%%%=%=%%====++++======*++====@@@#########@%=%@@@@@@%%%#####
// ################@@@@@@@@%@%%%%%%%=%%=======%%%=%%%%=%##################@@@@@@@@@@@@@%%%@
// #########################@@@@@@@@@@@@%%%@%@@@##########################@@@@@@@@@@@@@@@@@
//
// 
// Knyazev Sergey Alexandrovich
// 
// The results of a brain scan
// 
// No brain scans were performed
// 
// ----------------------------------------------------------------------------------------
// 
// Education and training
//
// Leningrad Institute of film engineers
// All-Union state Institute of cinematography
//
// Field of activity, specialization
// 
// Writer and poet
// 
// Results and achievements
// 
// Poetry
// 
// http://журнал-тропы.рф/
// http://reading-hall.ru/contents.php?id=2373
// http://reading-hall.ru/contents.php?id=1954
// http://ya-zemlyak.ru/avtpoesia.asp?id_avt=900
// https://magazines.gorky.media/ra/2009/8/opyt-molchaniya.html
// 
// Films
// 
// https://cloud.mail.ru/public/c4Ch/371pVoRgB
// https://cloud.mail.ru/public/3LHx/2iRtk6f5j
// https://cloud.mail.ru/public/aPCg/4XKcH1nBo
// https://www.youtube.com/watch?v=h4tOAL7EDkc
// https://www.youtube.com/watch?v=MkE4GnAKXzo
// 
// Website 1   http://nskd-studio.ru/node/25
// Website 2   http://kino-token.info/
// https://www.facebook.com/vetvi.lozi
// https://www.facebook.com/groups/FreeCripto/
// https://t.me/Knyazev_Sergey_Alexandrovich
// 
// The number of tokens is standard.
// ETH token network, static, flat.
// the contract was created by the team  http://kino-token.info/   (c)2020



library SafeMath {
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }
}

contract Token {

    uint256 public totalSupply;

    function balanceOf(address _owner) constant public returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) allowed;

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(_value <= balanceOf[msg.sender]);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(_value <= balanceOf[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

contract KNZV is StandardToken {
    function () public {
        revert();
    }

    string public name = "Knyazev SA token";
    uint8 public decimals = 8;
    string public symbol = "KNZV";
    uint256 public totalSupply = 1*10**17;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
}