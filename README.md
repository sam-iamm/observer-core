# observer-core

Observer posts Uniswap V3 oracle data on Starknet when price deviation or timed duration thresholds are met. Consumers of the oracle on StarkNet have access to the price feeds (e.g. ETH/USDC) from Uniswap with layer 1 liquidity. Bots on layer 1 are incentivized to push the oracle data up to StarkNet once price and duration thresholds are met through a >100% gas reimbursement.

## Deployed Addresses
Ethereum (Goerli) L1 Observer Contract: [0x66e453faf0f7CE1a4Aa1e03328213BdCB793C24c](https://goerli.etherscan.io/address/0x66e453faf0f7ce1a4aa1e03328213bdcb793c24c#code)  
Starknet (hackathon-0) L2 Observer Contract: [0x046c3bac376724a5548735c42f97700456f257207a3e204b6a931069a9e0c29c](https://hackathon-0.voyager.online/contract/0x046c3bac376724a5548735c42f97700456f257207a3e204b6a931069a9e0c29c#code)

## Active Oracles
Uniswap V3 WETH/USDC 0.05% (Goerli)
- oracle id: 0
- pool address: 0xfAe941346Ac34908b8D7d000f86056A18049146E
- base currency: WETH (0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6)
- quote currency: USDC (0x07865c6E87B9F70255377e024ace6630C1Eaa37F)
- TWAP period: 300 seconds = 5 minutes
- price deviation threshold: 0.5%
- duration threshold: 3600 seconds = 1 day
- caller incentive = +20% of base fee

## StarkNet Oracle Consumers
To consume the price feed on StarkNet, simply use call function `get_uni_v3_oracle_data` on the [L2 Observer Contract](https://hackathon-0.voyager.online/contract/0x046c3bac376724a5548735c42f97700456f257207a3e204b6a931069a9e0c29c#code) with the appropriate `oracle_id`.

The function returns a tuple of `(twap, last_updated_at)`. The TWAP is the price scaled to 1e18, and `last_updated_at` is the L1 update at `block.timestamp`.

```
# Returns the oracle data of the given oracle_id.
@view
func get_uni_v3_oracle_data{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(oracle_id : felt) -> (res : (felt, felt)):
    let (oracle_data) = uni_v3_oracles.read(oracle_id)
    return ((oracle_data[0], oracle_data[1])) 
end
```

## Layer 1 Bots
The Observer.sol contract holds the data for each respective oracle. Oracles have the following configurations relevant to bots:
- price deviation threshold = the percentage amount (in 1e4) the TWAP must change before updating the TWAP is incentivized
- duration threshold = time in seconds that must pass before updating the TWAP is incentivized
- base fee incentive multiplier = base fee multiplier for incentivizing bots scaled by 1e4 i.e. 12000 = 1.2x base fee
- incentive available = ETH on the contract earmarked as incentive payment for that specific oracle caller

Bots should monitor the `checkThresholds` function off-chain to check whether the price deviation or duration threshold has hit. If `checkThresholds` returns true in either value, then calling `updateUniV3Oracle` will return an incentive. To collect the incentive, call `updateUniV3Oracle` with the appropriate oracle id.

```
function checkThresholds(uint oracleId) public view onlyInitializedUniV3Oracle(oracleId) returns (bool deviationThreshold, bool durationThreshold) 
function updateUniV3Oracle(uint oracleId) external onlyInitializedUniV3Oracle(oracleId)
```

