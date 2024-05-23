// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessManagement {
    address public owner;
    mapping(string => mapping(string => Attribute)) public userAttributes; // fingerprint => attributeID => Attribute
    mapping(string => AccessPolicy) public accessPolicies; // attributeID => AccessPolicy

    struct Attribute {
        string key;
        string value;
        uint256 timestamp;
    }

    struct AccessPolicy {
        string attributeID;
        string platform;
        string permission;
    }

    event AttributeAdded(
        string fingerprint,
        string attributeKey,
        string attributeValue,
        uint256 timestamp
    );
    event AccessPolicyAdded(
        string attributeID,
        string platform,
        string permission
    );

    modifier onlyAuthorized() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addAttribute(
        string memory _fingerprint,
        string memory _attributeKey,
        string memory _attributeValue,
        uint256 _timestamp
    ) public {
        userAttributes[_fingerprint][_attributeKey] = Attribute(
            _attributeKey,
            _attributeValue,
            _timestamp
        );
        emit AttributeAdded(
            _fingerprint,
            _attributeKey,
            _attributeValue,
            _timestamp
        );
    }

    function getUserAttributes(
        string memory _fingerprint
    ) public view returns (Attribute[] memory) {
        uint256 count = getUserAttributesCount(_fingerprint);
        Attribute[] memory attributes = new Attribute[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < count; i++) {
            string memory attributeKey = uint256ToString(i); // Convert uint256 to string
            attributes[index] = userAttributes[_fingerprint][attributeKey];
            index++;
        }
        return attributes;
    }

    function getUserAttributesCount(
        string memory _fingerprint
    ) public view returns (uint256) {
        uint256 count = 0;
        while (
            bytes(userAttributes[_fingerprint][uint256ToString(count)].key)
                .length != 0
        ) {
            count++;
        }
        return count;
    }

    function uint256ToString(
        uint256 _value
    ) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint256 temp = _value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + (_value % 10)));
            _value /= 10;
        }
        return string(buffer);
    }

    function getAttribute(
        string memory _fingerprint,
        string memory _attributeKey
    ) public view returns (string memory, string memory, uint256) {
        Attribute memory attribute = userAttributes[_fingerprint][
            _attributeKey
        ];
        require(bytes(attribute.key).length != 0, "Attribute does not exist");
        return (attribute.key, attribute.value, attribute.timestamp);
    }

    function addAccessPolicy(
        string memory _attributeID,
        string memory _platform,
        string memory _permission
    ) public onlyAuthorized {
        accessPolicies[_attributeID] = AccessPolicy(
            _attributeID,
            _platform,
            _permission
        );
        emit AccessPolicyAdded(_attributeID, _platform, _permission);
    }

    function getAccessPolicy(
        string memory _attributeID,
        string memory _platform
    ) public view returns (string memory) {
        AccessPolicy memory policy = accessPolicies[_attributeID];
        require(
            keccak256(bytes(policy.platform)) == keccak256(bytes(_platform)),
            "No matching policy found"
        );
        return policy.permission;
    }
}
