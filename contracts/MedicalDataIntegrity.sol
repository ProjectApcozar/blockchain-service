// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MedicalDataIntegrity is Ownable {
    bytes32 private dataHash; //TO DELETE

    event DataHashUpdated(bytes32 indexed dataHash, uint256 indexed timestamp);
    
    constructor() Ownable(msg.sender) {}

    function updateDataHash(string memory _data) public onlyOwner() {
        dataHash = keccak256(abi.encodePacked(_data));
        emit DataHashUpdated(dataHash, block.timestamp);
    }

    function getDataHash() public view returns (bytes32) {
        return dataHash;
    }

    function verifyDataIntegrity(bytes32 _dataHash) public view returns (bool) {
        return dataHash == _dataHash;
    }
}