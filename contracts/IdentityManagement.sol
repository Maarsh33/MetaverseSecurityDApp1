// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdentityManagement {
    address public owner;
    mapping(address => string) public publicKeys;
    mapping(string => UserIdentity) public userIdentities;
    mapping(string => bool) public usedFingerprints;
    string[] public userIdentityKeys;

    struct UserIdentity {
        string username;
        string fingerprint;
        string publicKey;
    }

    event UserIdentityAdded(
        string username,
        string fingerprint,
        string publicKey
    );
    event UserIdentityRecovered(
        string username,
        string oldPublicKey,
        string newPublicKey
    );
    event UserIdentityRevoked(string username);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setPublicKey(
        string memory _publicKey
    ) public onlyOwner returns (bool) {
        publicKeys[msg.sender] = _publicKey;
        return true;
    }

    function retrievePublicKey() public view returns (string memory) {
        return publicKeys[msg.sender];
    }

    function addUserIdentity(
        string memory _username,
        string memory _fingerprint,
        string memory _publicKey
    ) public {
        require(
            bytes(userIdentities[_username].username).length == 0,
            "Username already exists"
        );
        require(!usedFingerprints[_fingerprint], "Fingerprint already used");

        userIdentities[_username] = UserIdentity(
            _username,
            _fingerprint,
            _publicKey
        );
        userIdentityKeys.push(_username);
        usedFingerprints[_fingerprint] = true;

        emit UserIdentityAdded(_username, _fingerprint, _publicKey);
    }

    function recoverUserIdentity(
        string memory _username,
        string memory _newPublicKey,
        string memory _fingerprint
    ) public {
        UserIdentity storage user = userIdentities[_username];
        require(bytes(user.username).length != 0, "User does not exist");
        require(
            keccak256(bytes(user.fingerprint)) ==
                keccak256(bytes(_fingerprint)),
            "Invalid fingerprint"
        );

        string memory oldPublicKey = user.publicKey;
        user.publicKey = _newPublicKey;

        emit UserIdentityRecovered(_username, oldPublicKey, _newPublicKey);
    }

    function revokeUserIdentity(
        string memory _username,
        string memory _fingerprint
    ) public {
        UserIdentity storage user = userIdentities[_username];
        require(bytes(user.username).length != 0, "User does not exist");
        require(
            keccak256(bytes(user.fingerprint)) ==
                keccak256(bytes(_fingerprint)),
            "Invalid fingerprint"
        );

        delete usedFingerprints[user.fingerprint];
        delete userIdentities[_username];

        emit UserIdentityRevoked(_username);
    }
}
