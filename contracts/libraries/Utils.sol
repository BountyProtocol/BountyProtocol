// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

/**
 * @dev General Utility Functions
 * TODO: Make functions public and attach library as an external contract
 *  https://hardhat.org/hardhat-runner/plugins/nomiclabs-hardhat-ethers#library-linking
 */
library Utils {
    using AddressUpgradeable for address;

    /// Match Two Strings
    function stringMatch(string memory str1, string memory str2) internal pure returns (bool) {
        return (keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2)));
    }

    /// Convert string to bytes32
    function stringToBytes32(string memory str) internal pure returns (bytes32) {
        require(bytes(str).length <= 32, "String is too long. Max 32 chars");
        return keccak256(abi.encode(str));
    }

    /// Convert bytes32 to string
    function bytes32ToString(bytes32 input_) internal pure returns (string memory) {
        return string(abi.encodePacked(input_));
    }

    /// Contract Type Logic
    function getAddressType(address account) internal view returns (string memory) {
        // console.log("** _getType() Return: ", response);
        if (account.isContract() && account != address(this)) {
            // console.log("THIS IS A Contract:", account);
            try IToken(account).symbol() returns (string memory response) {
                //Contract's Symbol
                return response;
            } catch {
                //Unrecognized Contract
                return "CONTRACT";
            }
        }
        // console.log("THIS IS NOT A Contract:", account);
        //Not a contract
        return "";
    }

    /*
    /// Concatenate Arrays (A Suboptimal Solution -- ~800Bytes)
    function arrayConcat(address[] memory Accounts, address[] memory Accounts2) private pure returns (address[] memory) {
        //Create a new container array
        address[] memory returnArr = new address[](Accounts.length + Accounts2.length);
        uint i=0;
        if(Accounts.length > 0) {
            for (; i < Accounts.length; i++) {
                returnArr[i] = Accounts[i];
            }
        }
        uint j=0;
        if(Accounts2.length > 0) {
            while (j < Accounts.length) {
                returnArr[i++] = Accounts2[j++];
            }
        }
        return returnArr;
    }
    */
}

/// Generic Interface used to get Token's Symbol
interface IToken {
    /// Arbitrary contract symbol
    function symbol() external view returns (string memory);
}
