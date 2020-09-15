/**
 *Submitted for verification at Etherscan.io on 2020-06-29
*/

pragma solidity >=0.5.7 <0.6.0;

/*
MIT License

Copyright (c) 2020 Daniel Britten

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// Facilitates a tree of points with pros and cons where only additions to the 'reasoning tree' can be made.
contract ReasoningTree {

    struct Node { // Point/Idea/Content
        string keyIdea; // Intended to be a brief key idea.
        string moreDetail; // Intended to include more detail such as explanation or a URL or ipfs link with even more information.
        address author; // Ethereum address of the person who submitted the key idea and more detail.
        uint[] pros; // Supporting points, 'Pros', which have been added later by anyone, accessible via retrieve or getKeyIdea.
        uint[] cons; // Negating points, 'Cons', which have been added later by anyone, accessible via retrieve or getKeyIdea.
    }
    
    mapping(uint => Node) nodes;
    uint nextId;
    uint[] topLevelNodes;
    event ReturnValue(address indexed _from, uint thisNodeId);

    constructor() public {
        nextId = 1; // Node Ids start from 1
    }
    
    function getTopLevelNodes() public view returns (uint[] memory) {
        return topLevelNodes;
    }

    // Sets the required details of the next node
    function setNextNodeDetails(uint thisNodeId, string memory newKeyIdea, string memory newMoreDetail, address author) private {
        nodes[thisNodeId].keyIdea = newKeyIdea;
        nodes[thisNodeId].moreDetail = newMoreDetail;
        nodes[thisNodeId].author = author;
    }

    // Add a Node/Point/Idea that is not linked to any parent Node
    function addNewTopic(string memory newKeyIdea, string memory newMoreDetail) public returns (uint thisNodeId) {
        thisNodeId = nextId;
        setNextNodeDetails(thisNodeId, newKeyIdea, newMoreDetail, msg.sender);
        topLevelNodes.push(thisNodeId);
        nextId = nextId + 1;
        emit ReturnValue(msg.sender, thisNodeId);
        return thisNodeId;
    }
    
    // Add a Node/Point/Idea that is either a pro or con of another Node
    function add(string memory newKeyIdea, string memory newMoreDetail, uint parent, bool supportsParent) public returns (uint thisNodeId) {
        require((0 < parent) && (parent < nextId), "The given parent must already exist.");
        thisNodeId = nextId;
        setNextNodeDetails(thisNodeId, newKeyIdea, newMoreDetail, msg.sender);
        if (supportsParent)
            nodes[parent].pros.push(thisNodeId);
        else
            nodes[parent].cons.push(thisNodeId);
        nextId = nextId + 1;
        emit ReturnValue(msg.sender, thisNodeId);
        return thisNodeId;
    }
    
    // Retrieve the details about a given Node
    function retrieve (uint nodeId) public view returns (string memory, string memory, address, uint[] memory, uint[] memory)  {
        require(nodeId > 0, "NodeIds start from 1.");
        require(nodeId < nextId, "The given node must already exist.");
        return (nodes[nodeId].keyIdea, nodes[nodeId].moreDetail, nodes[nodeId].author, nodes[nodeId].pros, nodes[nodeId].cons);
    }
    
    // Get the key idea of a given node
    function getKeyIdea(uint nodeId) public view returns (string memory) {
        require(nodeId > 0, "NodeIds start from 1.");
        require(nodeId < nextId, "The given node must already exist.");
        return nodes[nodeId].keyIdea;
    }
    
    // Get the current node count. NodeIds from 1 up to and including the node count will hold data.
    function nodeCount() public view returns (uint) {
        return nextId - 1; // NodeIds start from 1, so the count of current nodes is 1 less than nextId.
    }
}