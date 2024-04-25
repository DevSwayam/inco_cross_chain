// SPDX-License-Identifier: BSD-3-Clause-Clear
pragma solidity >=0.8.13 <0.9.0;

import "fhevm/abstracts/EIP712WithModifier.sol";
import "fhevm/lib/TFHE.sol";

interface IInterchainExecuteRouter {
    function getRemoteInterchainAccount(uint32 _destination, address _owner) external view returns (address);
}

contract RandomNumber is EIP712WithModifier {
    uint32 ChainID; 
    address public iexRouter; 
    address public caller_contract;
    
    constructor() EIP712WithModifier("Authorization token", "1") {
        ChainID = 17001;
        iexRouter = 0x4Bc0b9BD1d285F10AE69cef5B8ACbeaf1d28D71B;
    }
    
    function setCallerContract(address _caller_contract) public {
        caller_contract = _caller_contract;
    }

    function getICA() public view returns(address) {
        return IInterchainExecuteRouter(iexRouter).getRemoteInterchainAccount(ChainID, address(this));
    }
    
    modifier onlyCallerContract() {
        require(caller_contract == msg.sender, "not right caller contract");
        _;
    }
    
    mapping (address => euint16) public encryptedNumbers;

    function returnNumber(address user) external onlyCallerContract returns(uint16) {
        encryptedNumbers[user] = TFHE.rem(TFHE.randEuint16(), 100);
        return TFHE.decrypt(encryptedNumbers[user]);
    }

    function viewNumber(address user) external returns (uint16) {
        return TFHE.decrypt(encryptedNumbers[user]);
    }
}