# HuangGai(黄盖)
![logo](logo.png)


*HuangGai* is an Ethereum smart contract bug injection framework, it can inject 20 types of bugs into Solidity smart contract. *HuangGai* is compatible with multiple versions of Solidity (Solidity 0.5.x, 0.6.x, 0.7.x).

Users can use *HuangGai* to generate the large-scale vulnerable contract datasets without preparing contracts in advance (*HuangGai* integrates a contract crawler engine, of course, you can also use your contracts).

One of the goals of *HuangGai* is to inject bugs into the contract while keeping the original content of the contract as much as possible, so as to ensure the authenticity of the injected contracts (i.e.,  contracts that have been injected bugs by *HuangGai*).

For more information on *HuangGai*, we have a [paper](https://github.com/xf97/HuangGai/blob/master/OurPaper.pdf).

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

Enter the following commands in the terminal (eg., ubuntu os):
```
cd src/contractSpider/contractCodeGetter/data/
python3 autoCrawl.py
```
And you're done! The collected real contracts are stored in the folder `src/contractSpider/contractCodeGetter/sourceCode`.


**Note 1**: the default crawling URL of *ContractSpider* is [cn-etherscan](https://cn.etherscan.com/). We are not sure whether this URL can be accessed in non-China regions. If you encounter problems when collecting real contracts, please try to change the default crawling URL to [etherscan-io](http://etherscan.io/). Specifically, open folder `/src/contractSpider/contractCodeGetter/contractCodeGetter/spiders` and replace all `cn.etherscan.com` in (codeGetter, getContractAddressSpider, lastContractsAddress, nontokenContractAddress).py files with `etherscan.io`.

**Note 2**: To reduce the load of the crawled URL, the default crawl interval of *ContractSpider* is 5 seconds per contract. You can reduce or increase the interval by modifying the variable *DOWNLOAD_DELAY* (in seconds) in file `/src/contractSpider/contractCodeGetter/contractCodeGetter/spiders/setting.py`.

**Note 3**: You can also use your contracts (.sol files) by copying them to folder `src/contractSpider/contractCodeGetter/sourceCode`.

**Note 4**: You can also use the *real contract* dataset we collect, which is `sourceCodeDateSet.zip`. After decompressing the `sourceCodeDateSet.zip` (forgive me for my typo (data -> date).), you can get 66,205 *real contracts* and then copy these contracts to folder `src/contractSpider/contractCodeGetter/sourceCode`.

### Stage 2
Make sure that folder `src/contractSpider/contractCodeGetter/sourceCode` contains the *real contracts*, and then you can inject bugs into the contracts in the following two steps:
#### Step 1: Specify your needs
Now you should open the file `/src/userNeeds.json` and specify your needs by modifying the content of file `/src/userNeeds.json`. File `/src/userNeeds.json` requires you to specify the number of contracts containing each type of bugs and the maximum injection time.

Specifically, the content structure of file `/src/userNeeds.json` is as follows:
```
[bug type]: [the number of contracts you need to contain this type of bug, the time limit for injecting this type of bug (in minutes)]
```

#### Step 2: Start injecting
Enter the following commands in the terminal to start the injection (eg., ubuntu os):
```
cd src/
python3 main.py
```
And you're done! The injection result will be printed in the terminal.

## How to install
*HuangGai* requires Python 3.6+.

1. Clone source coode
```
git clone https://github.com/xf97/HuangGai
```

2. Install dependencies

*HuangGai* needs to use [Slither](https://github.com/crytic/slither) and [Scrapy](https://github.com/scrapy/scrapy), so please use the following commands to install dependencies:
```
cd HuangGai/
pip install --upgrade pip
pip install rich
pip install graphvi
pip install pydot
```

3. Install multiple *solc* versions

We use [solc-select](https://github.com/crytic/solc-select) to install multiple versions of solc:
```
cd ..
git clone https://github.com/crytic/solc-select.git
./solc-select/scripts/install.sh
```

This will install `solc` into `~/.solc-select/`, so you have to add it to the **PATH** variable. Add this line, replacing **USERNAME** with your username, to your `.bashrc` or equivalent:
```
export PATH=/home/USERNAME/.solc-select:$PATH
```

## Supported operating systems
At present, we have only tested *HuangGai* on Ubuntu (18.04).

## Datasets we provide
Through *HuangGai*, we generate and release the following 3 datasets:
1. **[Dataset 1](https://github.com/xf97/HuangGai/tree/master/manualCheckDataset)**: This dataset consists of 964 buggy contracts, covering 20 types of bugs, and 3 researchers who familiar with smart contract bugs check the injected bugs in these buggy contracts to ensure that all injected bugs can be activated (i.e., the injected bugs can be exploited by external attackers). As far as we know, **dataset 1** is currently the largest (number of contracts) buggy contract dataset with bug labels.
2. **[Dataset 2](https://github.com/xf97/HuangGai/tree/master/injectedContractDataSet)**: This dataset consists of 4,744 buggy contracts, covering 20 types of bugs. Users can use the contracts in **dataset 1** and **2** as the benchmark to evaluate the performance of analysis tools, to obtain the true performance of the analysis tools.
3. **[Dataset 3](https://github.com/xf97/HuangGai/blob/master/sourceCodeDateSet.zip)**: This dataset consists of 66,205 real contracts. Users can analyze the contracts in this dataset to know the current overview of Ethereum smart contracts.

## Issues
If you have any problems using *HuangGai*, please feel free to let me know at any time.


## License
This project is issued, reproduced or used under the permission of **MIT**. Please indicate the source when using.




