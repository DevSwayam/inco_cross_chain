// SPDX-License-Identifier: BSD-3-Clause-Clear
// @Dev this contract is for non inco network 

pragma solidity >=0.8.13 <0.9.0;

interface IInterchainExecuteRouter {
    function getRemoteInterchainAccount(uint32 _destination, address _owner) external view returns (address);
    // New
    function callRemote(uint32 _destination, address _to, uint256 _value, bytes calldata _data, bytes memory _callback) external returns (bytes32);
}

interface RandomNumber {
    function returnNumber(address user) external returns(uint16);
}

contract SlotMachine {

    uint32 ChainID; // Inco Chain Id = 9090
    address rngContract; // Random Number Generator contract on Inco Network = 0xC3180fe621A63Fb21EfCF66FA2253CBc28CC834C
    address iexRouter; // 
    address caller_contract;
    bool public isInitialized;
    uint16 lastRandomNumber;

    constructor(){
        ChainID = 9090;
        iexRouter = 0xAa3a222f42D034BC45a732827888e2C152591592;
        caller_contract = 0xAa3a222f42D034BC45a732827888e2C152591592;
    }

    function initialize( address _rngContract) public {
        require(isInitialized == false, "Bridge contract already initialized");
        rngContract = _rngContract; 
        isInitialized = true;
    }
    
    function setCallerContract(address _caller_contract) onlyCallerContract public {
        caller_contract = _caller_contract;
    }

    function getICA() public view returns(address) {
        return IInterchainExecuteRouter(iexRouter).getRemoteInterchainAccount(ChainID, address(this));
    }
    
    modifier onlyCallerContract() {
        require(caller_contract == msg.sender, "not right caller contract");
        _;
    }

    function getRandomNumber(address user) public {
        RandomNumber _rng = RandomNumber(rngContract);

        bytes memory _callback = abi.encodePacked(this.spin.selector, (uint256(uint160(msg.sender))));

        IInterchainExecuteRouter(iexRouter).callRemote(
            ChainID,
            address(_rng),
            0,
            abi.encodeCall(_rng.returnNumber, (user)),
            _callback
        );
    }

    function spin(uint256 user,uint16 _rndNumber) onlyCallerContract external {
        lastRandomNumber = _rndNumber;
    }
    
    function randomNumberView() public view returns(uint256) {
        return lastRandomNumber;
    }
}