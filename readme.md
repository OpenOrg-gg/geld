**Warning**:
Geld is an early stage prototype that was built as a hackathon project in a single weekend. It has not been rigorously tested and should be used with caution.

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

**Note**:

At this time, Geld has no public discord, telegram, Twitter or other channels. All updates will be in this repo or from @adamscochran on Twitter

**Info**:

Geld: 0xb9ed1C3337891a119F7A91BC6a9377B50A50e3D6

Bronze Pick: 0x93FB874026E79009b6CE35ce9FB904EFBd025478

Leveling Model: 0xF5adc59f1aFb16dA0c99E5fbfE0DB42CcBD11038

Exp Tracker: 0xD30B9816011c1987814367555E2ad808F1ecCF40