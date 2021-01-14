# HuangGai(黄盖)
![logo](logo.png)


*HuangGai* is an Ethereum smart contract bug injection framework, it can inject 20 types of bugs into Solidity smart contract. *HuangGai* is compatible with multiple versions of Solidity (Solidity 0.5.x, 0.6.x, 0.7.x).

Users can use *HuangGai* to generate the large-scale and vulnerable contract datasets without preparing contracts in advance (*HuangGai* integrates a contract crawler engine, of course, you can also use your contracts).

*HuangGai* can inject the following 20 types of bugs into the contracts (the names and definitions of the bugs are from our *[Jiuzhou](https://github.com/xf97/JiuZhou)* classification framework):

| Num | Bug type |
|:-----:|:-----:|
| 1 | Transaction order dependence |
| 2 | Results of contract execution affected by miners |
| 3 | Unhandled exception |
| 4 | Integer overflow and underflow |
| 5 | Use *tx.origin* for authentication |
| 6 | Re-entrancy |
| 7 | Wasteful contracts |
| 8 | Short address attack |
| 9 | Suicide contractse |
| 10 | Locked ether |
| 11 | Forced to receive ether |
| 12 | Pre-sent ether |
| 13 | Uninitialized local/state variables |
| 14 | Hash collisions with multiple variable length  arguments |
| 15 | Specify *function* variable as any type |
| 16 | Dos by complex *fallback* function |
| 17 | *public* function that could be declared  *external* |
| 18 | Non-public variables are accessed by *public*/*external* |
| 19 | Nonstandard naming |
| 20 | Unlimited compiler versions |

## Why do we name this framework *HuangGai*?
*Huang Gai* was a famous general of *Wu* state during the *Three Kingdoms period*. His most well-known achievement was: in the battle of *Chibi* in the 13th year of Jian'an (208 AD), *Huang Gai* went to *Cao Cao*'s camp to pretend to surrender (the **bitter meat tactics**) and took the opportunity to attack *Cao Cao*'s army with fire.