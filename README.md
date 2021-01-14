# HuangGai(黄盖)
*HuangGai* is an Ethereum smart contract bug injection framework, it can inject 20 types of bugs into Solidity smart contract. *HuangGai* is compatible with multiple versions of Solidity (Solidity 0.5.x, 0.6.x, 0.7.x, and 0.8.x is coming soon).

Users can use *HuangGai* to generate the large-scale and vulnerable contract datasets without preparing contracts in advance (*HuangGai* integrates a contract crawler engine, of course, you can also use your contracts).

*HuangGai* can inject the following 20 types of bugs into the contracts (the names and definitions of the bugs are from our *[Jiuzhou](https://github.com/xf97/JiuZhou)* classification framework):

| Num | Bug type |
| 1 | Transaction order dependence |