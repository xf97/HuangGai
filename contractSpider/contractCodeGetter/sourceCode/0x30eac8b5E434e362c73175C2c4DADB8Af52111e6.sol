/**
 *Submitted for verification at Etherscan.io on 2020-06-19
*/

pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

//SPDX-License-Identifier: BSD-3-Clause
//Copyright (c) 2020 Joshua Herron. All rights reserved.

struct Post {
    address author;
    string title;
    string content;
}

struct Comment {
    address author;
    string content;
}

contract API {
    Post[] public posts;
    mapping (address => uint256[]) public userposts;
    mapping (uint256 => Comment[]) public postcomments;
    
    function newPost(string memory title, string memory content) public returns (uint256 postid) {
        posts.push(Post (msg.sender, title, content));
        userposts[msg.sender].push(posts.length-1);
        return (posts.length-1);
    }
    
    function getPost(uint256 postid) public view returns (address author, string memory title, string memory content, address[] memory, string[] memory) {
        author = posts[postid].author;
        title = posts[postid].title;
        content = posts[postid].content;
        Comment[] memory comments = postcomments[postid];
        uint256 commlength = comments.length;
        address[] memory commentauthors = new address[](commlength);
        string[] memory commentcontents = new string[](commlength);
        for (uint256 i = 0; i < comments.length; i++) {
            commentauthors[i] = comments[i].author;
            commentcontents[i] = comments[i].content;
        }
        return (author, title, content, commentauthors, commentcontents);
    }
    
    function newComment(uint256 postid, string memory content) public returns (bool done) {
        postcomments[postid].push(Comment (msg.sender, content));
        return (true);
    }
    
    function getPosts(uint256 offset) public view returns (uint256[] memory, address[] memory, string[] memory, string[] memory) {
        if (posts.length > 0) {
            uint256 arrlength;
            if (posts.length >= 20) {
                arrlength = 20;
            } else {
                arrlength = posts.length;
            }
            uint256[] memory postids = new uint256[](arrlength);
            address[] memory authors = new address[](arrlength);
            string[] memory titles = new string[](arrlength);
            string[] memory contents = new string[](arrlength);
            uint256 length = posts.length-offset-1;
            uint256 min;
            if (length >= 19) {
                min = length-19;
            } else {
                min = 0;
            }
            for (uint256 i = min; i <= length; i++) {
                postids[length-i] = i;
                authors[length-i] = posts[i].author;
                titles[length-i] = posts[i].title;
                contents[length-i] = posts[i].content;
            }
            return (postids, authors, titles, contents);
        } else {
            uint256[] memory postids = new uint256[](0);
            address[] memory authors = new address[](0);
            string[] memory titles = new string[](0);
            string[] memory contents = new string[](0);
            return (postids, authors, titles, contents);
        }
    }
    
    function getUserPosts(address user) public view returns (uint256[] memory, string[] memory, string[] memory) {
        uint256 userpostcount = userposts[user].length;
        uint256[] memory postids = new uint256[](userpostcount);
        string[] memory titles = new string[](userpostcount);
        string[] memory contents = new string[](userpostcount);
        postids = userposts[user];
        for (uint256 i = 0; i < postids.length; i++) {
            titles[i] = posts[postids[i]].title;
            contents[i] = posts[postids[i]].content;
        }
        return (postids, titles, contents);
    }
}