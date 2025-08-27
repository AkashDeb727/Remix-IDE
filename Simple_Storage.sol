// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract SimpleStorage {

    address public immutable owner;

    mapping(address => uint256[]) public addressToFavNum;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setFavNum(uint256 _num) public payable {
        require((msg.value >= 0.001 ether), "Send at least 0.001 ETH");
        addressToFavNum[msg.sender].push(_num);
    }

    function resetFavNums() public {
        delete addressToFavNum[msg.sender];
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function highestFavNumber() public view returns(uint256) {
        uint256[] memory fav= addressToFavNum[msg.sender];
        uint256 max = fav[0];

        for(uint256 i = 0; i < fav.length; i++){
            if(fav[i] > max){
                max = fav[i];
            }
        }
        
        return max;
    }
}
