// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//import ERC721 and ERC721Burnable
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721{ //Inheriting from ERC721
    
    uint256 tokenId; //tokenId
    uint serialNo; //Serial Number of Product
    string productName; //Name of Product
    address owner; //Address of Owner of Product
    address retailer; //Address of retailer/brand of product
    uint createdTime; //Time of Sale of product
    uint warrantyPeriod; //Warranty Period of product
    uint expirationTime; //Time of expiration of warranty
    

    constructor(address _owner, string memory _productName, uint _serialNo,uint _warrantyPeriod) ERC721("ProductNFT","PRO"){ //setting default values
        retailer = msg.sender;
        productName = _productName;
        serialNo = _serialNo;
        createdTime = block.timestamp;
        warrantyPeriod = _warrantyPeriod*1; //2628288
        expirationTime = warrantyPeriod+createdTime;
        owner = _owner;
    }

    //custom modifier to check if function caller is owner of NFT or retailer of NFT
    modifier isOwnerORRetailer(){
        require((msg.sender==owner) || (msg.sender==retailer),"Only owner or retailer can view this info!");
        _;
    }

    //custom modifier to check if function caller is retailer of NFT
    modifier isRetailer(){
        require(msg.sender==retailer,"Only retailer can change owner of the product!");
        _;
    }

    //function to check warranty status of product, and if expired, burn the nft
    function checkStatus(uint _tokenId) public isOwnerORRetailer returns(bool){
        if(block.timestamp>expirationTime){
            _burn(_tokenId);
            return (false);
        }
        else{
            return (true);
        }
    }

    
    //function to change owner in case of resale.
    function changeOwner(address _newOwner) public isOwnerORRetailer {
        owner = _newOwner;
    }

    //function to mint nft
    function mint(uint256 _tokenId,address _owner) public isOwnerORRetailer{
        _safeMint(_owner,_tokenId);
    }

    //function which returns address of retailer
    function getRetailer() public view returns(address){
        return retailer;
    }

    //function which returns address of owner
    function getOwner() public view returns(address){
        return owner;
    }

    //function to prove ownership of nft
    function confirmOwner() public view returns(bool){
        if(owner==msg.sender)
            return (true);
        else
            return (false);
    }

    //function to get time of sale
    function getCreationTime() public view isOwnerORRetailer returns(uint){
        return createdTime;
    }

    //function to get warranty period of product
    function getWarrantyPeriod() public view isOwnerORRetailer returns(uint){
        return warrantyPeriod;
    }

    //function to get expiration time of nft
    function getExpirationTime() public view isOwnerORRetailer returns(uint){
        return expirationTime;
    }
}