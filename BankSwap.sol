// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;


contract test{
    struct Request{
        string name;
        string description;
        uint val;
    }
    mapping(uint=>Request) public request;
    address public manager;
    address[] interstPerson;
    mapping(address=>uint) public interster;
    uint public noOfStakers;

    mapping(address=>uint) public Customer;
    uint public bankAmount=address(this).balance;

    uint public intestRate=1000 wei;
    uint public noOfCust;

    receive() payable external{}

    constructor() {
        manager=msg.sender;
    }

    function deposit() public payable{
        require(msg.sender!=manager,"Your not abble becouase Your a manger");
        require(msg.value>=1 ether,"Not enough money");
        if(Customer[msg.sender]==0){
            noOfCust++;
        }
        Customer[msg.sender]+=msg.value;
    }
    function balances(address cust) public view returns(uint){
        require(msg.sender!=manager,"Your not abble becouase Your a manger");
        return Customer[msg.sender];
    }

    function widraw(uint amount) public payable{
        require(msg.sender!=manager,"Your not abble becouase Your a manger");
        require(Customer[msg.sender]>=amount,"Your Amount Limit has suceed");
        Customer[msg.sender]-=amount;        
        address payable user=payable(msg.sender);
        user.transfer(amount);
        if(Customer[msg.sender]==amount){
            Customer[msg.sender]=0;
        }
    }

    function transferFrom(address from,address to, uint amount) public payable{
        require(msg.sender!=manager,"Your not able");
        require(from!=address(0) || to!=address(0),"Plz enter the values");
        require(Customer[msg.sender]>0 || Customer[msg.sender]>=msg.value,"Sorry not enough money");
        require(Customer[msg.sender]>=amount,"sorry apka pas paisa nai ha");
        Customer[msg.sender]-=amount;
        Customer[to]+=amount;
        if(Customer[msg.sender]==amount){
            Customer[msg.sender]=0;
        }
    }    

    function loanRequest(uint id,string memory _name,string memory _dris,uint _val) public {
        require(msg.sender!=manager,"Bosri k hat ja");
        Request storage ThisReq=request[id];
        ThisReq.name=_name;
        ThisReq.description=_dris;
        ThisReq.val=_val;
    }

    function getApproved() public returns(bool)  {
        require(msg.sender==manager,"Bosri k hat ja");
        return true;        
    }

    function getLoan(uint id,uint amount) public payable {
        require(msg.sender==manager,"Your not be abble");
        require(msg.value<=5 ether ,"Not enough Money");
        require(address(this).balance>0,"Bank have dont balance");
        require(getApproved()==true,"not be able");
        Request storage ThisReq=request[id];
        require(ThisReq.val>=amount,"Your a chater");
        (bool sendi,)=payable(msg.sender).call{value:amount}("");
        require(sendi,"Nikal yahn sa");
    }

    function interest(uint amount) public payable{
        require(msg.value<=intestRate,"Plz insert correct amount");
    }

    function stakingEth(uint amount) public payable{
        require(msg.value>=5 ether,"Your not able to stake");
        require(msg.sender!=manager,"Sorry manger cant acces this function");
        if(interster[msg.sender]==0){
            noOfStakers++;
        }
        interster[msg.sender]+=amount;
        interstPerson.push(msg.sender);
    }

    function getInterest() public payable {
        require(msg.sender!=manager,"Sorry manger cant acces this function");
        // require(interstPerson[msg.sender]==msg.sender,"Nikal ");
        for(uint i=0;i<interstPerson.length;i++){
            if(interstPerson[i]==msg.sender){
                address payable user=payable(msg.sender);
                user.transfer(intestRate);
            }
        }
    }

}