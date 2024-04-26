// SPDX-License-Identifier: BSD-3-Clause-Clear

/* 
This contract is an example contract to demonstrate 
the cross-chain function call using ExecuteAPI 
on the inco chain.
*/

pragma solidity >=0.8.13 <0.9.0;

import "fhevm/abstracts/EIP712WithModifier.sol";
import "fhevm/lib/TFHE.sol";

interface IInterchainExecuteRouter {

    function getRemoteInterchainAccount(uint32 _destination, address _owner)
        external
        view
        returns (address);

}

interface IRandomNumber {
    function returnNumber(address user) external returns(uint16);
}

contract RandomNumber is EIP712WithModifier,IRandomNumber {

    mapping (address => euint16) public encryptedNumbers;
    uint32 DestinationDomain;
    address public iexRouter;
    address public caller_contract;

    constructor() EIP712WithModifier("Authorization token", "1") {
    }

    function initialize(uint32 _DestinationDomain, address _caller_contract, address _iexRouter) public {
        DestinationDomain = _DestinationDomain;
        iexRouter = _iexRouter;
        caller_contract = _caller_contract;
    }

    // A random encrypted uint8 is generated
    function returnNumber(address user) external returns(uint16) {
        require(caller_contract == msg.sender, "not right caller contract");
        encryptedNumbers[user] = TFHE.randEuint16();
        return TFHE.decrypt(encryptedNumbers[user]);
    }

    //function decryptRandomNumber(address user) external returns (uint16) {
    //    return TFHE.decrypt(encryptedNumbers[user]);
    //}

    function getICA(address _contract) public view returns(address) {
        return IInterchainExecuteRouter(iexRouter).getRemoteInterchainAccount(DestinationDomain, _contract);
    }
}