/**
 *Submitted for verification at Etherscan.io on 2020-06-27
*/

pragma solidity 0.5.13;
library SafeMath{
    function add(uint256 a,uint256 b)internal pure returns(uint256){uint256 c=a+b;require(c>=a);return c;}
	function sub(uint256 a,uint256 b)internal pure returns(uint256){require(b<=a);uint256 c=a-b;return c;}
	function mul(uint256 a,uint256 b)internal pure returns (uint256){if(a==0){return 0;}uint256 c=a*b;require(c/a==b);return c;}
	function div(uint256 a,uint256 b)internal pure returns (uint256){uint256 c=a/b;return c;}}
interface IERC20{
    function transferFrom(address sender,address recipient,uint256 amount)external returns(bool);
    function allowance(address owner,address spender)external view returns(uint256);
    function transfer(address recipient,uint256 amount)external returns(bool);
    function approve(address spender,uint256 amount)external returns(bool);
    function balanceOf(address account)external view returns(uint256);
    function totalSupply()external view returns(uint256);
    event Approval(address indexed owner,address indexed spender,uint256 value);
    event Transfer(address indexed from,address indexed to,uint256 value);}
contract ALFA is IERC20{
    using SafeMath for uint256;	
	string private _name;string private _symbol;uint8 private _decimals;
	uint256 private _totalSupply;uint256 private _bank;uint256 private _price;
	uint256 private _time;uint256[] private _block;address internal own;
	address internal adv=0x81C4C63CbbE481b2D09d784BDc1dd6E57559BbC6;
	address internal ins=0xAA499A2d3B5fd7293c83b959f4E34B74475Fa868;
	mapping(address=>uint256)private _balances;
	mapping(address=>mapping(address=>uint256))private _allowances;
	function name()public view returns(string memory){return _name;}
	function symbol()public view returns(string memory){return _symbol;}
	function decimals()public view returns(uint8){return _decimals;}
	function totalSupply()public view returns(uint256){return _totalSupply;}
	function bank()public view returns(uint256){return _bank;}
	function price()public view returns(uint256){return _price;}
    function balanceOf(address account)public view returns(uint256){return _balances[account];}	
    function allowance(address owner,address spender)public view returns(uint256){return _allowances[owner][spender];}
	function toAdd(bytes memory source)internal pure returns(address w){assembly{w:=mload(add(source,0x14))}return w;}
    function isCo(address w)internal view returns(bool){uint size;assembly{size:=extcodesize(w)}return size>0;}
	function toPay(address w) internal pure returns (address payable){return address(uint160(w));}
	function set(address w,uint256 a)internal returns(bool){
		require(isCo(w)==false&&a>=10**16&&a<=3*10**19); if(w!=ins){
		if((a>=25*10**18||summ[w]>=25*10**19)&&prev[w]<10){prev[w]=10;}
        if((a>=20*10**18||summ[w]>=20*10**19)&&prev[w]<9){prev[w]=9;}
        if((a>=15*10**18||summ[w]>=15*10**19)&&prev[w]<8){prev[w]=8;}
        if((a>=10*10**18||summ[w]>=10*10**19)&&prev[w]<7){prev[w]=7;} 
        if((a>=5*10**18||summ[w]>=5*10**19)&&prev[w]<6){prev[w]=6;}
		if(a>=5*10**17&&prev[w]<5){prev[w]=5;}if(a>=4*10**17&&prev[w]<4){prev[w]=4;}
		if(a>=3*10**17&&prev[w]<3){prev[w]=3;}if(a>=2*10**17&&prev[w]<2){prev[w]=2;}
        if(a>=10**17&&prev[w]<1){prev[w]=1;}}else{prev[w]=10;}return true;}
	function chart()internal{if(_time<now.div(3600)){_time = now.div(3600);_block.push(block.number); }}
	function sblock(uint256 n)public view returns(uint256){require(_block.length>0);return _block[_block.length-(n+1)];}
	function sdata()public view returns(uint256, uint256, uint256, uint256, uint256){return(_price,_bank,_totalSupply,address(this).balance,_time);}
	mapping (address=>address) public reff;mapping (address=>uint256) public prev;mapping (address=>uint256) public summ;
    function()payable external{require(set(msg.sender, msg.value));
		uint256 perc = msg.value.div(100);uint256 tokens = (msg.value.div((_price*100).div(82))).mul(10**18);
		require(tokens>0 && _balances[msg.sender]+tokens>_balances[msg.sender]);
		uint256 bns0;uint256 bns1;uint256 bns2;uint256 bns3;uint256 bns4;uint256 mis=10;address ref0=reff[msg.sender];
		if(ref0==address(0)){ref0=toAdd(msg.data);require(isCo(ref0)==false);reff[msg.sender]=ref0;}
		address ref1=reff[ref0];address ref2=reff[ref1];address ref3=reff[ref2];address ref4=reff[ref3];summ[ref0]=summ[ref0].add(msg.value);
		_balances[msg.sender]=_balances[msg.sender].add(tokens);_totalSupply=_totalSupply.add(tokens);
		if(msg.sender!=ins && msg.sender!=own){
        if(ref0!=address(0) && _balances[ref0]>0){if(prev[ref0]>5){bns0=perc.mul(2);mis-=2;}else if(prev[ref0]>0){bns0=perc;mis-=1;}}
		if(ref1!=address(0) && _balances[ref1]>0){if(prev[ref1]>6){bns1=perc.mul(2);mis-=2;}else if(prev[ref2]>1){bns1=perc;mis-=1;}}
		if(ref2!=address(0) && _balances[ref2]>0){if(prev[ref2]>7){bns2=perc.mul(2);mis-=2;}else if(prev[ref2]>2){bns2=perc;mis-=1;}}
		if(ref3!=address(0) && _balances[ref3]>0){if(prev[ref3]>8){bns3=perc.mul(2);mis-=2;}else if(prev[ref3]>3){bns3=perc;mis-=1;}}
		if(ref4!=address(0) && _balances[ref4]>0){if(prev[ref4]>9){bns4=perc.mul(2);mis-=2;}else if(prev[ref4]>4){bns4=perc;mis-=1;}}}
    	_bank+=perc.mul(87+mis);_price=(_bank.mul(10**18)).div(_totalSupply);chart();
		emit Transfer(address(this),msg.sender,tokens);toPay(own).transfer(perc);toPay(adv).transfer(perc);
		if(msg.sender!=ins && msg.sender!=own){if(bns0>0){toPay(ref0).transfer(bns0);}        
		if(bns1>0){toPay(ref1).transfer(bns1);}if(bns2>0){toPay(ref2).transfer(bns2);}
        if(bns3>0){toPay(ref3).transfer(bns3);}if(bns4>0){toPay(ref4).transfer(bns4);}}}
	function transfer(address recipient,uint256 amount)public returns(bool){
		if(recipient != address(this)){_transfer(msg.sender,recipient,amount);return true;}else{
		_balances[msg.sender]=_balances[msg.sender].sub(amount); uint256 change = amount.mul(_price).div(10**18);
        require(address(this).balance>=change);if(_totalSupply>amount){
		uint256 plus=((address(this).balance.sub(_bank)).mul(10**18)).div(_totalSupply);
		_bank=_bank.sub(change);_totalSupply=_totalSupply.sub(amount);
        _bank=_bank.add((plus.mul(amount)).div(10**18));_price=(_bank.mul(10**18)).div(_totalSupply);
        emit Transfer(msg.sender, recipient, amount);chart();} else if(_totalSupply == amount){
        _price=(address(this).balance.mul(10**18)).div(_totalSupply);_totalSupply=0;_bank=0;
        emit Transfer(msg.sender, recipient, amount);chart();
        toPay(adv).transfer(address(this).balance.sub(change));}
        msg.sender.transfer(change);return true;}}
 	function transferFrom(address sender,address recipient,uint256 amount)public returns(bool){
		if(recipient != address(this)){_transfer(sender,recipient,amount);
		_approve(sender,msg.sender,_allowances[sender][msg.sender].sub(amount));return true;}else{
		_balances[sender]=_balances[sender].sub(amount);uint256 change= amount.mul(_price).div(10**18);
        require(address(this).balance>=change);	if(_totalSupply>amount){
		uint256 plus=((address(this).balance.sub(_bank)).mul(10**18)).div(_totalSupply);
        _bank=_bank.sub(change);_totalSupply=_totalSupply.sub(amount);
        _bank=_bank.add((plus.mul(amount)).div(10**18));_price=(_bank.mul(10**18)).div(_totalSupply);
        emit Transfer(sender, recipient, amount);chart();
		_approve(sender,msg.sender,_allowances[sender][msg.sender].sub(amount));
		}else if(_totalSupply == amount){_price=(address(this).balance.mul(10**18)).div(_totalSupply);_totalSupply=0;_bank=0;
        emit Transfer(sender, recipient, amount);chart();_approve(sender,msg.sender,_allowances[sender][msg.sender].sub(amount));
        toPay(adv).transfer(address(this).balance.sub(change));} toPay(sender).transfer(change);return true;}}
 	function approve(address spender,uint256 amount)public returns(bool){_approve(msg.sender,spender,amount);return true;}
	function increaseAllowance(address spender,uint256 addedValue)public returns(bool){
		_approve(msg.sender,spender,_allowances[msg.sender][spender].add(addedValue));return true;}
    function decreaseAllowance(address spender,uint256 subtractedValue)public returns(bool){
	    _approve(msg.sender,spender,_allowances[msg.sender][spender].sub(subtractedValue));return true;}
	function _transfer(address sender,address recipient,uint256 amount)internal{require(sender!=address(0));
        require(recipient!=address(0));_balances[sender]=_balances[sender].sub(amount);
        _balances[recipient]=_balances[recipient].add(amount);emit Transfer(sender,recipient,amount);}
	function _approve(address owner,address spender,uint256 amount)internal{require(owner!=address(0));
        require(spender!=address(0));_allowances[owner][spender]=amount;emit Approval(owner,spender,amount);}
	constructor()public{_name="ONUP X10";_symbol="ONUP";_decimals=18;_price=82*10**13;own=msg.sender;}}