// SPDX-License-Identifier: Apache-2.0

/* 
This contract is an example contract to demonstrate 
the cross-chain function call using ExcuteAPI 
on the base chain.
*/

pragma solidity >=0.8.13 <0.9.0;

interface IInterchainExecuteRouter {

    function callRemote(
        uint32 _destination,
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes memory _callback
    ) external returns (bytes32);

    function getRemoteInterchainAccount(uint32 _destination, address _owner)
        external
        view
        returns (address);

}

interface RandomNumber {
    function returnNumber(address user) external returns(uint16) ;
}

contract SlotMachine {
    
    uint32 DestinationDomain;
    // HiddenCard contract in Inco Network
    address randomNumber;
    // InterchainExcuteRouter contract address in current chain
    address iexRouter;
    address caller_contract;
    bytes32 messageId;
    mapping (address => uint16) public randomNumbers;

    function initialize(uint32 _DestinationDomain, address _randomNumber, address _iexRouter, address _caller_contract) public {
        DestinationDomain = _DestinationDomain;
        randomNumber = _randomNumber;
        iexRouter = _iexRouter;
        caller_contract = _caller_contract;
    }

    function GetNumber(address user) public {
        RandomNumber _randomNumber = RandomNumber(randomNumber);

        bytes memory _callback = abi.encodePacked(this.spinSlotMachine.selector,(uint256(uint160(user))));

        messageId = IInterchainExecuteRouter(iexRouter).callRemote(
            DestinationDomain,
            address(_randomNumber),
            0,
            abi.encodeCall(_randomNumber.returnNumber,(user)),
            _callback
        );
    }

    function spinSlotMachine(uint256 user, uint16 _rn) external {
        require(caller_contract == msg.sender, "not right caller contract"); // ?
        randomNumbers[address(uint160(user))] = _rn;
    }

    function ViewSlotMachineNumber(address user) public view returns(uint16) {
        return randomNumbers[user];
    }

    function getICA(address _contract) public view returns(address) {
        return IInterchainExecuteRouter(iexRouter).getRemoteInterchainAccount(DestinationDomain, _contract);
    }

}