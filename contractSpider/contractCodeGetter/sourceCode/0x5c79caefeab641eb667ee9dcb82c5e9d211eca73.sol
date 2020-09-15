/**
 *Submitted for verification at Etherscan.io on 2020-07-19
*/

pragma solidity ^0.4.21;
/***
 *         _____                                               ___           ___     
 *        /  /::\       ___           ___        ___          /  /\         /  /\    
 *       /  /:/\:\     /  /\         /__/\      /  /\        /  /:/_       /  /:/_   
 *      /  /:/  \:\   /  /:/         \  \:\    /  /:/       /  /:/ /\     /  /:/ /\  
 *     /__/:/ \__\:| /__/::\          \  \:\  /__/::\      /  /:/ /:/_   /  /:/ /::\ 
 *     \  \:\ /  /:/ \__\/\:\__   ___  \__\:\ \__\/\:\__  /__/:/ /:/ /\ /__/:/ /:/\:\
 *      \  \:\  /:/     \  \:\/\ /__/\ |  |:|    \  \:\/\ \  \:\/:/ /:/ \  \:\/:/~/:/
 *       \  \:\/:/       \__\::/ \  \:\|  |:|     \__\::/  \  \::/ /:/   \  \::/ /:/ 
 *        \  \::/        /__/:/   \  \:\__|:|     /__/:/    \  \:\/:/     \__\/ /:/  
 *         \__\/         \__\/     \__\::::/      \__\/      \  \::/        /__/:/   
 *                                     ~~~~                   \__\/         \__\/    
 *  v 1.1.0
 *  "Spread the Love"
 *
 *  Ethereum Commonwealth.gg Divies(based on contract @ ETC:0x93123bA3781bc066e076D249479eEF760970aa32)
 *  Modifications: 
 *  -> reinvest Crop Function
 *
 *  What?
 *  -> eWLTH div interface. Send ETH here, and then call distribute to give to eWLTH holders.
 *  -> Distributes 75% of the contract balance.
 * 
 *                                ┌────────────────────┐
 *                                │ Usage Instructions │
 *                                └────────────────────┘
 * Transfer funds directly to this contract. These will be distributed via the distribute function.
 *   
 *    address diviesAddress = 0xd1A231ae68eBE7Aec3ECDAEAC4C0776eB525D969;
 *    diviesAddress.transfer(232000000000000000000); 
 * 
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
interface HourglassInterface {
    function() payable external;
    function buy(address _playerAddress) payable external returns(uint256);
    function sell(uint256 _amountOfTokens) external;
    function reinvest() external;
    function withdraw() external;
    function exit() external;
    function dividendsOf(address _playerAddress, bool) external view returns(uint256);
    function balanceOf(address _playerAddress) external view returns(uint256);
    function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
    function stakingRequirement() external view returns(uint256);
}

contract Divies {
    using SafeMath for uint256;
    using UintCompressor for uint256;
    address private eWLTHAddress = 0x5833C959C3532dD5B3B6855D590D70b01D2d9fA6;

    HourglassInterface constant eWLTH = HourglassInterface(eWLTHAddress);
    
    uint256 public pusherTracker_ = 100;
    mapping (address => Pusher) public pushers_;
    struct Pusher
    {
        uint256 tracker;
        uint256 time;
    }

    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // BALANCE
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    function balances()
        public
        view
        returns(uint256)
    {
        return (address(this).balance);
    }
    
    
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // DEPOSIT
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    function deposit()
        external
        payable
    {
        
    }
    
    // used so the distribute function can call hourglass's withdraw
    function() external payable {}
    
    
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // EVENTS
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    event onDistribute(
        address pusher,
        uint256 startingBalance,
        uint256 finalBalance,
        uint256 compressedData
    );
    /* compression key
    [0-14] - timestamp
    [15-29] - caller pusher tracker 
    [30-44] - global pusher tracker 
    */  
    
    
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // DISTRIBUTE
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    function distribute()
        public
    {
        uint256 _percent = 75;
        // data setup
        address _pusher = msg.sender;
        uint256 _bal = address(this).balance;
        uint256 _compressedData;
        
        // update pushers wait que 
        pushers_[_pusher].tracker = pusherTracker_;
        pusherTracker_++;
            
        // setup _stop.  this will be used to tell the loop to stop
        uint256 _stop = (_bal.mul(100 - _percent)) / 100;
            
        // buy & sell    
        eWLTH.buy.value(_bal)(address(0));
        eWLTH.sell(eWLTH.balanceOf(address(this)));
            
        // setup tracker.  this will be used to tell the loop to stop
        uint256 _tracker = eWLTH.dividendsOf(address(this), true);
    
        // reinvest/sell loop
        while (_tracker >= _stop) 
        {
            // lets burn some tokens to distribute dividends to eWLTH holders
            eWLTH.reinvest();
            eWLTH.sell(eWLTH.balanceOf(address(this)));
                
            // update our tracker with estimates (yea. not perfect, but cheaper on gas)
            _tracker = (_tracker.mul(81)) / 100;
        }
            
        // withdraw
        eWLTH.withdraw();
        
        // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
        pushers_[_pusher].time = now;
    
        // prep event compression data 
        _compressedData = _compressedData.insert(now, 0, 14);
        _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
        _compressedData = _compressedData.insert(pusherTracker_, 30, 44);

        // fire event
        emit onDistribute(_pusher, _bal, address(this).balance, _compressedData);
    }
}


/**
* @title -UintCompressor- v0.1.9
*/
library UintCompressor {
    using SafeMath for *;
    
    function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
        internal
        pure
        returns(uint256)
    {
        // check conditions 
        require(_end < 77 && _start < 77);
        require(_end >= _start);
        
        // format our start/end points
        _end = exponent(_end).mul(10);
        _start = exponent(_start);
        
        // check that the include data fits into its segment 
        require(_include < (_end / _start));
        
        // build middle
        if (_include > 0)
            _include = _include.mul(_start);
        
        return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
    }
    
    function extract(uint256 _input, uint256 _start, uint256 _end)
	    internal
	    pure
	    returns(uint256)
    {
        // check conditions
        require(_end < 77 && _start < 77);
        require(_end >= _start);
        
        // format our start/end points
        _end = exponent(_end).mul(10);
        _start = exponent(_start);
        
        // return requested section
        return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
    }
    
    function exponent(uint256 _position)
        private
        pure
        returns(uint256)
    {
        return((10).pwr(_position));
    }
}

/**
 * @title SafeMath v0.1.9
 * @dev Math operations with safety checks that throw on error
 * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
 * - added sqrt
 * - added sq
 * - added pwr 
 * - changed asserts to requires with error log outputs
 * - removed div, its useless
 */
library SafeMath {
    
    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) 
        internal 
        pure 
        returns (uint256 c) 
    {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b);
        return c;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b)
        internal
        pure
        returns (uint256) 
    {
        require(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b)
        internal
        pure
        returns (uint256 c) 
    {
        c = a + b;
        require(c >= a);
        return c;
    }
    
    /**
     * @dev gives square root of given x.
     */
    function sqrt(uint256 x)
        internal
        pure
        returns (uint256 y) 
    {
        uint256 z = ((add(x,1)) / 2);
        y = x;
        while (z < y) 
        {
            y = z;
            z = ((add((x / z),z)) / 2);
        }
    }
    
    /**
     * @dev gives square. multiplies x by x
     */
    function sq(uint256 x)
        internal
        pure
        returns (uint256)
    {
        return (mul(x,x));
    }
    
    /**
     * @dev x to the power of y 
     */
    function pwr(uint256 x, uint256 y)
        internal 
        pure 
        returns (uint256)
    {
        if (x==0)
            return (0);
        else if (y==0)
            return (1);
        else 
        {
            uint256 z = x;
            for (uint256 i=1; i < y; i++)
                z = mul(z,x);
            return (z);
        }
    }
}