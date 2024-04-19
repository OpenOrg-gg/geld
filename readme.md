
**Current Scope**:
/assetMinter/itemMinter.sol
/assetMinter/pickMinter.sol
/items/food/berry.sol (Attempts to implement unibot style fee on swap pool with Geld instead of eth)
/items/picks/Bronze.sol (Should implement a straight fee on swap pool)
/mechanics/fatigue.sol (A system where users gain X days of energy for 'eating' items (ERC-20 tokens), if fatigue is at zero it impacts their mining ability)
/skills/miningExpContract.sol (A system to track user mining experience)
/skills/miningLevelContract.sol (A system to convert between exp and levels in mining skill)
/geld.sol

**New changes to Geld.sol**:
-Broke mint out into mulitple functions to better track
-Removed initial mint to streamline mining math


**Breakdown of Mint**:
-Mint checks that it is not reentrant, that minting is active, and that it's been at least 10 seconds since the last block.
-Then if there is an external simpleHook set for crank turning, it turns that crank.
-It then checks if we've replaced the challengeInterface with an external version, if not, we move to *mintInternal()*

*mintInternal()*
-We abi.encodePacked the challengeNumber, sender and nonce
-We check that the minter is not on the list of the last 3 successful minters (this prevents whales monopolizing early mining)
-We check that the call is not from a contract to prevent pools or other mining risks.
-We then require that the digest and challenge digest match, and check if the digest is smaller than the mining target.
-If it is, we update the solution.
-We then add the minter to the *lastThreeMinters* index
-Now we process the reward.

*_processReward()*
-We pull in what the mining reward should be based on the Era math.
-We pass this to *_processRewardWithDigestAndAmount()* when passing from internal the digest isn't used, but this function retains it to be compatible with external versions later.

*_processRewardWithDigestAndAmount()*:
-We check the energy level of the user.
-If they are on their last energy, or have 0 energy, their reward is set to 3 Geld (the lowest possible reward)
-We then process their mining pick bonuses in *_updateMiningPick*
-The *_updateMiningPick* function checks if they get any bonuses from a mining pick, and if not records the base reward_amount and exp_reward and returns it to the prior function.
-We then mint out rewards to sender, and use *_payOutRewards()* to add to the revenue fee and team fee.
-We update the *_setLastRewardData()* data to track rewards
-And lastly we update the users experience.
-We then pass back true all the way into mintInternal()


**Additional Key Checks**:
-Prior versions had an issue with mapping of _approve() and being able to approve the router for swapback function. We should double check that the remapping works correctly.

**Geld**:

Geld is a useful-Proof-of-Work (uPoW) token on the Base blockchain.

Users can mine Geld by using the Geld CPU miner (https://github.com/OpenOrg-gg/geldMiner)

Users systems try and guess a value under a certain target hash, and if correct "mine" a meta-block. The system automatically targets meta-blocks to take place each 10 minutes, and so, every 4096 blocks readjusts the target difficulty to get closer to the target time.

The goal of Geld however is to make this work useful, rather than just guessing arbitrary hashes.

Geld can achieve this in two ways, first by updating a simpleHook to turn any arbitrary crank (such as updating an oracle, or turning the crank on an onchain CLOB).

The second is by updating the internal proof check mechanism, which can be routed through an external router to support mulitple types of proofs. In theory, this would allow systems like Geld to instead target proofs that proof ZK transactions, side channel transactions, verify offline data state, or just about anything else.

Geld is deeply inspired by, and based on the code of 0xBitcoin, with a number of changes:

-Users now earn "mining skill exp" when they mine

-Users can equip different tiers of "pickaxes" represented by ERC-20 tokens that provide bonuses to their exp and the amount the earn when mining. **note**: pickaxes won't be live on day one, still need an interface for them.

-A users pickaxe balance declines (representing durability) with each successful mining attempt.

-The rate of their pickaxe declining is influenced by their overall mining level.

-Geld and pickaxes have fee on swap mechanics, inspired by Unibot.
-The revenue sharing fee from pickaxes and other future game items flow to Geld holders.

-Future high tier items are only purchasable in Geld.

-Future addons will include crafting of mining supplies, and other random adventures.

The goal here is to make a prototype of either a PoW token or game, in which users simply don't care about the other function taking place underneath.

This allows us to arbitrarily spread the cost of various 'crank-turning' mechanics across thousands of users and offload the cost of key public goods.

While Geld iself, due to its lack of testing, could break or fail to properly upgrade to this state - the goal is for it to inspire a new design pattern that can be used.

**Socials**:

Discord: https://discord.gg/A7P8gRxX2v

Twitter: https://twitter.com/BaseGeld

DevTwitter: @adamscochran

**Info**:

Geld: 0xbC2E1C09c270c5Ccf469E5aD272892c6B9DdB283

Bronze Pick: 0x39BD39025b0826D3c67D2CC7A4717E50380FBe8b

Iron Pick: 0xF56F21b2B32d597ab22b4e5aec9ebdAbd72d7c39

Leveling Model: 0xF5adc59f1aFb16dA0c99E5fbfE0DB42CcBD11038

Exp Tracker: 0xaB4409789FBF1Eb4bf3aca99aB051C3627FA3D65