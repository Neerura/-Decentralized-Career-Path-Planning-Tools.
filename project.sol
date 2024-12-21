// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CareerPathPlanning {

    struct CareerPath {
        string careerGoal;
        string skillsRequired;
        uint256 progress; // from 0 to 100
        address user;
        uint256 timestamp;
    }

    mapping(address => CareerPath[]) public userCareerPaths;
    mapping(address => bool) public registeredUsers;

    event CareerPathCreated(address indexed user, string careerGoal, uint256 timestamp);
    event CareerPathUpdated(address indexed user, string careerGoal, uint256 progress, uint256 timestamp);

    modifier onlyRegisteredUsers() {
        require(registeredUsers[msg.sender], "You must be a registered user");
        _;
    }

    modifier userExists(address _user) {
        require(registeredUsers[_user], "User not registered");
        _;
    }

    // Function to register a user
    function registerUser() public {
        require(!registeredUsers[msg.sender], "User already registered");
        registeredUsers[msg.sender] = true;
    }

    // Function to create a career path
    function createCareerPath(string memory _careerGoal, string memory _skillsRequired) public onlyRegisteredUsers {
        CareerPath memory newCareerPath = CareerPath({
            careerGoal: _careerGoal,
            skillsRequired: _skillsRequired,
            progress: 0,
            user: msg.sender,
            timestamp: block.timestamp
        });
        userCareerPaths[msg.sender].push(newCareerPath);
        emit CareerPathCreated(msg.sender, _careerGoal, block.timestamp);
    }

    // Function to update progress of a career path
    function updateCareerPathProgress(uint256 _index, uint256 _progress) public onlyRegisteredUsers userExists(msg.sender) {
        require(_progress <= 100, "Progress must be between 0 and 100");
        CareerPath storage careerPath = userCareerPaths[msg.sender][_index];
        careerPath.progress = _progress;
        emit CareerPathUpdated(msg.sender, careerPath.careerGoal, _progress, block.timestamp);
    }

    // Function to get all career paths for a user
    function getCareerPaths() public view returns (CareerPath[] memory) {
        return userCareerPaths[msg.sender];
    }

    // Function to get a specific career path by index
    function getCareerPath(address _user, uint256 _index) public view returns (CareerPath memory) {
        require(userCareerPaths[_user].length > _index, "Career path does not exist at this index");
        return userCareerPaths[_user][_index];
    }
}
