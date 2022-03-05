//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "contracts/access/Ownable.sol";
import "contracts/utils/Strings.sol";
import "contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "contracts/utils/Counters.sol";

contract BKHNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;
    bool public _isSaleActive = true;
    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public cost = 0.03 ether;
    uint256 public presaleCost = 0.01 ether;
    uint256 public maxSupply = 8888;
    uint256 public maxMintAmount = 10;
    bool public _revealed = false;
    bool public paused = false;
    

    //uint256[] private _specialIds;
    //using Strings for uint256;
    //using Counters for Counters.Counter;
    
    //Counters.Counter private _tokenIds;
    //Counters.Counter private _reserved;
    
    //mapping(uint256 => string) private _generationURIs;
    //mapping(uint256 => string) private _specialsURIs;
    
    //event Birth(uint256 quantity);

    //-----------------------------------
    mapping(address => bool) public whitelisted;
    mapping(address => bool) public presaleWallets;
    mapping(address => uint256) public addressMintedBalance;
    mapping(uint256 => string) private _tokenURIs;
    

 
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        string memory initNotRevealedUri
    ) 
    ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        //mint(msg.sender, 888);
        setNotRevealedURI(initNotRevealedUri);
        mintSpecificID(8888);
        mintSpecificID(8887);
        mintSpecificID(8886);
        mintSpecificID(8885);
        mintSpecificID(8884);
        mintSpecificID(8883);
        mintSpecificID(8882);
        mintSpecificID(8881);
        mintSpecificID(8880);
        mintSpecificID(8879);
        mintSpecificID(8878);
        mintSpecificID(8877);
    }
  //------------------------------------------------------  
    //function giveSpecial(address _to, string memory _uri, uint256 _amount) public onlyOwner() {//++
       // require(_reserved.current() > 0, "No more specials to give");
        //require(_reserved.current() >= _amount, "Not enough specials to give away");
        
       // for(uint256 i = 0; i < _amount; i++){
       //     _reserved.decrement();
       //     _tokenIds.increment();
            
         //   uint mintIndex = _tokenIds.current();
        //    _safeMint(_to, mintIndex);
            
        //    _specialIds.push(mintIndex);
        //    _specialsURIs[mintIndex] = _uri;
       // }
   // }
    
    //function getSpecialIds() external view returns(uint256[] memory) {
        //return _specialIds;
    //}
//++


    // public
    function mint(address _to, uint256 _mintAmount) public payable { //function mint(address _to, uint256 _mintAmount) 
        uint256 supply = totalSupply();
        //if(msg.sender != owner()){
        require(_isSaleActive, "Sale must be active to mint BK Homies");
        require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply + _mintAmount <= maxSupply);
        require(!checkForIDConflicts(_mintAmount, supply), "_mintAmount goes over a token ID range with ID conflicts, change _mintAmount or try again later");
       // }
        if (msg.sender != owner()) {
            if (whitelisted[msg.sender] != true) {
                if (presaleWallets[msg.sender] != true) {
                    //general public
                    require(msg.value >= cost * _mintAmount);
                } else {
                    //presale
                    require(msg.value >= presaleCost * _mintAmount);
                }
            }
        }

    
//***
       // for (uint256 i = 1; i <= _mintAmount; i++) {
         //   if(!_exists(supply + i)) {
         //     addressMintedBalance[msg.sender]++;    
         //     _safeMint(msg.sender, supply + i);
         //     }
         //   else{_safeMint(msg.sender, supply+i);}
        //}
//***

        for (uint256 i = 1; i <= _mintAmount; i++) {
            _safeMint(_to, supply-12 + i);
        }
    }

//----------------------------------------------------------
    function checkForIDConflicts(uint256 _mintAmount, uint256 supply) internal view returns(bool) {
      bool idConflicts;

      for (uint i = 1; i < _mintAmount; i++) {
        if (_exists(supply + i)) {idConflicts = true;}
    }

    return idConflicts;
  }
//----------------------------------------------------------




    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i); 
        }
        return tokenIds;
    }



    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        if (_revealed == false) {
            return notRevealedUri;
        }
       string memory _tokenURI = _tokenURIs[tokenId];


        string memory base = _baseURI();
        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return
            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
                        
   } 

   // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //only owner

//-------------------------------------------
function mintSpecificID(uint256 ID) public payable onlyOwner {
      require(!paused);
      uint256 supply = totalSupply();
      
      require(supply + 1 <= maxSupply);
      _safeMint(msg.sender, ID);
  }
//-------------------------------------------------



    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }


    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setPresaleCost(uint256 _newCost) public onlyOwner {
        presaleCost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function whitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = true;
    }

    function removeWhitelistUser(address _user) public onlyOwner {
        whitelisted[_user] = false;
    }

    function addPresaleUser(address _user) public onlyOwner {
        presaleWallets[_user] = true;
    }

    function add100PresaleUsers(address[100] memory _users) public onlyOwner {
        for (uint256 i = 0; i < 2; i++) {
            presaleWallets[_users[i]] = true;
        }
    }

    function removePresaleUser(address _user) public onlyOwner {
        presaleWallets[_user] = false;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
