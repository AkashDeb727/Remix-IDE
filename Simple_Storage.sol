// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title Simple Storage of Favorite Numbers
/// @author Akash
/// @notice This contract allows users to store, view, and clear their favorite numbers by paying a small ETH fee.
/// @dev Contract owner can withdraw all collected ETH.
contract SimpleStorage {

    /// @notice The address of the contract owner (set at deployment).
    address public immutable owner;

    /// @notice Mapping of user addresses to their list of favorite numbers.
    mapping(address => uint256[]) private userToFavNums;
    
    /// @notice Restricts function access to only the contract owner.
    modifier onlyOwner {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    /// @notice Initializes the contract and sets the deployer as the owner.
    constructor() {
        owner = msg.sender;
    }

    /// @notice Store a new favorite number by paying at least 0.001 ETH.
    /// @dev Adds the given `_num` to the sender's favorite number list.
    /// @param _num The favorite number to store.
    function addFavNum(uint256 _num) public payable {
        require(msg.value >= 0.001 ether, "Send at least 0.001 ETH");
        userToFavNums[msg.sender].push(_num);
    }

    /// @notice View all your favorite numbers.
    /// @dev Returns an array of numbers stored by `msg.sender`.
    /// @return An array of uint256 values representing the user's favorite numbers.
    function getMyFavNums() public view returns (uint256[] memory) {
        return userToFavNums[msg.sender];
    }

    /// @notice Delete all your stored favorite numbers.
    /// @dev Clears the storage array for the caller.
    function clearFavNums() public {
        delete userToFavNums[msg.sender];
    }

    /// @notice Withdraw all ETH stored in this contract.
    /// @dev Only callable by the contract owner. Uses call for safe transfer.
    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    /// @notice Get the highest favorite number you have stored.
    /// @dev Loops through the caller's stored array and finds the maximum.
    /// @return max The highest number in the caller's stored favorites.
    function highestFavNumber() public view returns (uint256 max) {
        uint256[] memory fav = userToFavNums[msg.sender];
        require(fav.length > 0, "No favorite numbers found");

        max = fav[0];
        for (uint256 i = 1; i < fav.length; i++) {
            if (fav[i] > max) {
                max = fav[i];
            }
        }
    }
}
