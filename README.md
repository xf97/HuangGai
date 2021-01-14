# HuangGai(黄盖)
![logo](logo.png)


*HuangGai* is an Ethereum smart contract bug injection framework, it can inject 20 types of bugs into Solidity smart contract. *HuangGai* is compatible with multiple versions of Solidity (Solidity 0.5.x, 0.6.x, 0.7.x).

Users can use *HuangGai* to generate the large-scale and vulnerable contract datasets without preparing contracts in advance (*HuangGai* integrates a contract crawler engine, of course, you can also use your contracts).

One of the goals of *HuangGai* is to inject bugs into the contract while keeping the original content of the contract as much as possible, so as to ensure the authenticity of the injected contracts (i.e.,  contracts that have been injected bugs by *HuangGai*).

For more information on Bugs, we have a [paper](https://github.com/xf97/HuangGai/blob/master/OurPaper.pdf).

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
*Huang Gai* was a famous general of *Wu* state during the *Three Kingdoms period*. His most well-known achievement was: in the battle of *Chibi* in the 13th year of Jian'an (208 AD), *Huang Gai* went to *Cao Cao*'s camp to pretend to surrender and took the opportunity to attack *Cao Cao*'s army with fire.

We hope that this bug injection framework, like *Huang Gai*, is superficially a surrender of the enemy (generating a large number of vulnerable contracts), but actually the bug injection framework is helping us win (helping to evaluate the smart contract analysis tools and further promote the progress of the analysis tools).

## How to use
### Stage 1
First, you need to collect *real contracts* (i.e., smart contracts deployed on Ethereum) before injecting bugs into contracts. *HuangGai* integrates a contract spider (we call this spider *ContractSpider*) developed based on [Python scrapy framework](https://github.com/scrapy/scrapy), which can collect tens of thousands of real contracts in several hours.

Enter the following instructions in the terminal (eg., ubuntu os):
```
cd src/contractSpider/contractCodeGetter/data/
python3 autoCrawl.py
```
And you're done! The collected real contracts are stored in the folder `src/contractSpider/contractCodeGetter/sourceCode`.


**Note 1**: the default crawling URL of *ContractSpider* is [cn-etherscan](https://cn.etherscan.com/). We are not sure whether this URL can be accessed in non-China regions. If you encounter problems when collecting real contracts, please try to change the default crawling URL to [etherscan-io](http://etherscan.io/). Specifically, open folder `/src/contractSpider/contractCodeGetter/contractCodeGetter/spiders` and replace all `cn.etherscan.com` in (codeGetter, getContractAddressSpider, lastContractsAddress, nontokenContractAddress).py files with `etherscan.io`.

**Note 2**: To reduce the load of the crawled URL, the default crawl interval of *ContractSpider* is 5 seconds per contract. You can reduce or increase the interval by modifying the variable *DOWNLOAD_DELAY* (in seconds) in file `/src/contractSpider/contractCodeGetter/contractCodeGetter/spiders/setting.py`.

**Note 3**: You can also use your contracts by copying them to folder `src/contractSpider/contractCodeGetter/sourceCode`.

### Stage 2


