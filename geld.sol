pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
// OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)

/* pragma solidity ^0.8.0; */

/* import "../IERC20.sol"; */

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
            _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
            _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

interface IChallengeInterface{
    function challengeCheck(bytes32 digest, bytes32 challenge_digest, bytes32 challengeNumber, address sender, uint256 nonce, uint256 challengeType) external view returns(bool _pass, uint256 _mul);
    function getChallengeNumber() external view returns(bytes32, uint256);
    function newChallengeNumber() external view returns(bytes32);
    function getMiningDifficulty() external view returns(uint256);
    function getMiningTarget() external view returns(uint256);
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

////// src/IUniswapV2Pair.sol
/* pragma solidity 0.8.10; */
/* pragma experimental ABIEncoderV2; */

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}
// ----------------------------------------------------------------------------

// '0xBitcoin Token' contract

// Mineable ERC20 Token using Proof Of Work

//

// Symbol      : GELD

// Name        : Base Geld

// Total supply: 210,000,000.00

// Decimals    : 18

//


// ----------------------------------------------------------------------------



// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function sub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function mul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function div(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}



library ExtendedMath {


    //return the smaller of the two inputs (a or b)
    function limitLessThan(uint a, uint b) internal pure returns (uint c) {

        if(a > b) return b;

        return a;

    }
}

interface IExpContract {
    function miningExp(address _user) external view returns(uint256);
    function updateMining(address _user, uint256 _add, uint256 _sub) external;

}

interface ILevelContract {
    function getLevel(uint256 _user) external view returns(uint256);
}

interface ISimpleHook {
    function turnCrank() external;
}

interface IFatigue {
    function returnFatigue(address _user) external view returns (uint256);
}

// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and an

// initial fixed supply

// ----------------------------------------------------------------------------

contract Geld is ERC20 {
    bool private _isMinting;
    bool public transferPause;
    using SafeMath for uint;
    using ExtendedMath for uint;

    address owner;
    address expContract;
    address levelContract;
    address challengeInterface;
    address simpleHookAddress;
    address fatigue;

    uint256 lastBlockTimestamp;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address public constant deadAddress = address(0xdead);

    bool private swapping;

    address public revShareWallet;
    address public teamWallet;
    address public characterInfo;

    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;

    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;

    bool public blacklistRenounced = false;
    address[3] public lastThreeMinters;
    uint public index = 0;

    // Anti-bot and anti-whale mappings and variables
    mapping(address => bool) blacklisted;

    mapping(address => bool) internalMinter;

    mapping(uint256 => address) public miningPickClassToAddress;
    mapping(address => uint) public miningPickClassAddress;
    mapping(address => bool) public approvedMiningPicks;

    mapping(address => uint256) public miningPickClass;
    mapping(address => uint256) public miningPickBalance;

    uint256 public buyTotalFees;
    uint256 public buyRevShareFee;
    uint256 public buyLiquidityFee;
    uint256 public buyTeamFee;

    uint256 public sellTotalFees;
    uint256 public sellRevShareFee;
    uint256 public sellLiquidityFee;
    uint256 public sellTeamFee;

    uint256 public tokensForRevShare;
    uint256 public tokensForLiquidity;
    uint256 public tokensForTeam;

    /******************/

    // exclude from fees and max transaction amount
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public _isExcludedMaxTransactionAmount;

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping(address => bool) public automatedMarketMakerPairs;

    bool public preMigrationPhase = true;
    mapping(address => bool) public preMigrationTransferrable;


    uint public _totalSupply;

    uint public latestDifficultyPeriodStarted;


    uint public epochCount;//number of 'blocks' mined


    uint public _BLOCKS_PER_READJUSTMENT = 2048;


    //a little number
    uint public  _MINIMUM_TARGET = 2**15;


      //a big number is easier ; just find a solution that is smaller
    //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
    uint public  _MAXIMUM_TARGET = 2**234;


    uint public miningTarget;

    bytes32 public challengeNumber;   //generate a new one when a new reward is minted


    uint public rewardEra;
    uint public maxSupplyForEra;


    address public lastRewardTo;
    uint public lastRewardAmount;
    uint public lastRewardEthBlockNumber;

    bool locked = false;
    bool mintOn = false;

    mapping(bytes32 => bytes32) solutionForChallenge;

    uint public tokensMinted;

    mapping(address => uint) balances;


    mapping(address => mapping(address => uint)) allowed;


    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);

    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor() ERC20("GELD", "Base Geld") {
        owner = msg.sender;
        _totalSupply = 2_100_000_000 * 1e18;

        if(locked) revert();
        locked = true;

        tokensMinted = 0;

        rewardEra = 0;
        maxSupplyForEra = _totalSupply.div(2);

        miningTarget = _MAXIMUM_TARGET;

        latestDifficultyPeriodStarted = block.number;

        _startNewMiningEpoch();

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24
        );

        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6)
            .createPair(address(this), 0x4200000000000000000000000000000000000006);
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        uint256 _buyRevShareFee = 1;
        uint256 _buyLiquidityFee = 1;
        uint256 _buyTeamFee = 1;

        uint256 _sellRevShareFee = 1;
        uint256 _sellLiquidityFee = 2;
        uint256 _sellTeamFee = 2;

        buyRevShareFee = _buyRevShareFee;
        buyLiquidityFee = _buyLiquidityFee;
        buyTeamFee = _buyTeamFee;
        buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;

        sellRevShareFee = _sellRevShareFee;
        sellLiquidityFee = _sellLiquidityFee;
        sellTeamFee = _sellTeamFee;
        sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;

        maxTransactionAmount = 2_100_000_000 * 10e18; //override
        maxWallet = 2_100_000_000 * 10e18; // override 
        swapTokensAtAmount = (100_000_000 * 5) / 10000; // 0.05% 

        revShareWallet = address(0xd5F617f173dDBcFA516Fe6281d2619134F98a839); // set as revShare wallet
        teamWallet = address(0xd5F617f173dDBcFA516Fe6281d2619134F98a839); // set as team wallet

        // exclude from paying fees or having max transaction amount
        excludeFromFees(owner, true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        excludeFromMaxTransaction(owner, true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);

        preMigrationTransferrable[owner] = true;
        _isMinting = false;
        mintOn = true;

        levelContract = address(0xF5adc59f1aFb16dA0c99E5fbfE0DB42CcBD11038);
        expContract = address(0x53a5D6172e1e8754e97BDCBdB0C4b726d3d7e7b1);

    }

    function setMiningPick(address _address, uint256 _class) public {
        require(msg.sender == owner);
        miningPickClassAddress[_address] = _class;
    }

    function setSimpleHook(address _address) public {
        require(msg.sender == owner);
        simpleHookAddress = _address;
    }

    function updateBlocksPer(uint256 _blocks) public {
        require(msg.sender == owner);
        _BLOCKS_PER_READJUSTMENT = _blocks;
    }

    function setMint(bool _bool) public {
        require(msg.sender == owner);
        mintOn = _bool;
    }

    function setMiningPickToAddress(address _address, uint256 _class) public {
        require(msg.sender == owner);
        miningPickClassToAddress[_class] = _address;
    }

    function approveMiningPick(address _address, bool _bool) public {
        require(msg.sender == owner);
        approvedMiningPicks[_address] = _bool;
    }

    function setLevelsContract(address _address) public {
        require(msg.sender == owner);
        levelContract = _address;
    }    
    
    function setExpContract(address _address) public {
        require(msg.sender == owner);
        expContract = _address;
    }

    function depositPicks(address _address, uint256 _amount) public {
        require(approvedMiningPicks[_address] == true);
        if(miningPickClass[msg.sender] == miningPickClassAddress[_address]){
            require(IERC20(_address).transferFrom(msg.sender, address(this), _amount));
            miningPickBalance[msg.sender] += _amount;
        }
        if(miningPickClass[msg.sender] == 0){
            require(IERC20(_address).transferFrom(msg.sender, address(this), _amount));
            miningPickBalance[msg.sender] += _amount;
            miningPickClass[msg.sender] = miningPickClassAddress[_address];
        }
    }

    function resetStuckUserPicks(address _address) public {
        require(msg.sender == owner);
        miningPickClass[_address] = 0;
        miningPickBalance[_address] = 0;
    }

    function withdrawPicks(address _address, uint256 _amount) public {
        if(_amount >= miningPickBalance[msg.sender] && miningPickClass[msg.sender] == miningPickClassAddress[_address]){
            require(IERC20(_address).transfer(msg.sender, _amount));
            miningPickBalance[msg.sender] -= _amount;
            if(miningPickBalance[msg.sender] == 0){
                miningPickClass[msg.sender] = 0;
            }
        }
    }

function mint(uint256 nonce, bytes32 challenge_digest, uint256 challengeType) public returns (bool success) {
    require(!_isMinting, "Minting already in progress");
    require(mintOn == true);
    require(block.timestamp > lastBlockTimestamp + 10);
    _isMinting = true;

    if (simpleHookAddress != address(0)) {
        ISimpleHook(simpleHookAddress).turnCrank();
    }

    bytes32 internalChallengeNumber = challengeNumber;

    if (challengeInterface == address(0)) {
        success = mintInternal(nonce, challenge_digest, internalChallengeNumber);
    } else {
        success = mintExternal(nonce, challenge_digest, challengeType);
    }

    if (success) {
        _startNewMiningEpoch();
        emit Mint(msg.sender, lastRewardAmount, epochCount, challengeNumber);
    }

    _isMinting = false;
    return success;
}

function mintInternal(uint256 nonce, bytes32 challenge_digest, bytes32 internalChallengeNumber) internal returns (bool) {
    // The PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
    bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));

    //require not recent minter
    require(isAddressRecentMinter(msg.sender) == false);

    //block contracts
    require(msg.sender == tx.origin);

    // The challenge digest must match the expected
    require(digest == challenge_digest, "Challenge digest mismatch");

    // The digest must be smaller than the target
    require(uint256(digest) <= miningTarget, "Digest not small enough");

    bytes32 solution = solutionForChallenge[internalChallengeNumber];
    solutionForChallenge[internalChallengeNumber] = digest;
    require(solution == 0, "Duplicate solution");  // Prevent the same answer from awarding twice

    //add to last 3 minters
    lastThreeMinters[index] = msg.sender;
    index = (index + 1) % 3;

    return _processReward();
}

function mintExternal(uint256 nonce, bytes32 challenge_digest, uint256 challengeType) internal returns (bool) {
    // The PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
    bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));

    //require not recent minter
    require(isAddressRecentMinter(msg.sender) == false);

    //block contracts
    require(msg.sender == tx.origin);

    (bool pass, uint256 mul) = IChallengeInterface(challengeInterface).challengeCheck(digest, challenge_digest, challengeNumber, msg.sender, nonce, challengeType);
    if (!pass) {
        return false;
    }

    if (mul > 1) {
        uint256 reward_amount = getMiningReward() * mul;
        return _processRewardWithAmount(reward_amount);
        lastThreeMinters[index] = msg.sender;
        index = (index + 1) % 3;
    } else {
        return _processReward();
        lastThreeMinters[index] = msg.sender;
        index = (index + 1) % 3;
    }
}

function _processReward() internal returns (bool) {
    uint256 reward_amount = getMiningReward();
    return _processRewardWithAmount(reward_amount);
}

function _processRewardWithAmount(uint256 reward_amount) internal returns (bool) {
    bytes32 dig = bytes32(0);
    return _processRewardWithDigestAndAmount(dig, reward_amount);
}

function _processRewardWithDigestAndAmount(bytes32 digest, uint256 reward_amount) internal returns (bool) {
    uint256 energy = IFatigue(fatigue).returnFatigue(msg.sender);
    if(energy <= 1){
        reward_amount = 3e18;
    }
    uint exp_reward;
    (exp_reward, reward_amount) = _updateMiningPick(reward_amount);
    _mint(msg.sender, reward_amount);
    _payOutRewards(reward_amount);
    _setLastRewardData(reward_amount);
    IExpContract(expContract).updateMining(msg.sender, exp_reward, 0);

    assert(tokensMinted <= maxSupplyForEra);
    return true;
}

function _updateMiningPick(uint256 reward_amount) internal returns (uint256, uint256) {
    uint256 exp_reward = 1;
    if (miningPickClass[msg.sender] != 0) {
        uint256 exp = IExpContract(expContract).miningExp(msg.sender);
        uint256 lvl = ILevelContract(levelContract).getLevel(exp);
        uint256 burnAmt = 1e18 * (100 - lvl) / 100;
        if (miningPickBalance[msg.sender] >= burnAmt) {
            miningPickBalance[msg.sender] -= burnAmt;
        } else {
            miningPickBalance[msg.sender] = 0;
        }
    }

    if (miningPickClass[msg.sender] != 0 && miningPickBalance[msg.sender] > 1e18) {
        reward_amount += (reward_amount * (miningPickClass[msg.sender]) / 100);
        if (miningPickClass[msg.sender] >= 2) {
            exp_reward += (miningPickClass[msg.sender] / 2);
        }
    }
    return (exp_reward, reward_amount);
}

function _payOutRewards(uint256 reward_amount) internal {
    _mint(address(this), ((reward_amount * 2) / 100));
    _mint(teamWallet, ((reward_amount * 3) / 100));
    tokensMinted = tokensMinted.add(reward_amount + ((reward_amount * 2) / 100) + ((reward_amount * 3) / 100));
}

function _setLastRewardData(uint256 reward_amount) internal {
    // Set readonly diagnostic data
    lastRewardTo = msg.sender;
    lastRewardAmount = reward_amount;
    lastRewardEthBlockNumber = block.number;
}

    function internalMint(address _address, uint256 _amount) public {
        require(internalMinter[msg.sender] == true || msg.sender == owner);
        super._mint(_address, _amount);
        tokensMinted = tokensMinted.add(_amount);
    }

    function editMinter(address _address, bool _bool) public {
        require(msg.sender == owner);
        internalMinter[_address] = _bool;
    }

    //a new 'block' to be mined
    function _startNewMiningEpoch() internal {

      //if max supply for the era will be exceeded next reward round then enter the new era before that happens

      if( tokensMinted.add(getMiningReward()) > maxSupplyForEra)
      {
        rewardEra = rewardEra + 1;
      }

      //set the next minted supply at which the era will change
      // total supply is 21000000000000000  because of 18 decimal places
      maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));

      epochCount = epochCount.add(1);

      //every so often, readjust difficulty. Dont readjust when deploying
      if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
      {
        _reAdjustDifficulty();
      }


      //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
      //do this last since this is a protection mechanism in the mint() function
      if(challengeInterface == address(0)){
        challengeNumber = blockhash(block.number - 1);
      } else {
        challengeNumber = blockhash(block.number - 1);
        challengeNumber = IChallengeInterface(challengeInterface).newChallengeNumber();
      }
    }


    //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
    //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days

    //readjust the target by 5 percent
    function _reAdjustDifficulty() internal {


        uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;

        //we want miners to spend 10 minutes to mine each 'block', about 300 base blocks = one geld epoch
        uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256

        uint targetEthBlocksPerDiffPeriod = epochsMined * 300; //should be 60 times slower than ethereum

        //if there were less eth blocks passed in time than expected
        if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
        {
          uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );

          uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
          // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.

          //make it harder
          miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
        }else{
          uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );

          uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000

          //make it easier
          miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
        }



        latestDifficultyPeriodStarted = block.number;

        if(miningTarget < _MINIMUM_TARGET) //very difficult
        {
          miningTarget = _MINIMUM_TARGET;
        }

        if(miningTarget > _MAXIMUM_TARGET) //very easy
        {
          miningTarget = _MAXIMUM_TARGET;
        }
    }


    //this is a recent ethereum block hash, used to prevent pre-mining future blocks
    function getChallengeNumber() public view returns (bytes32, uint) {
        if(challengeInterface == address(0)){
            return (challengeNumber, 0);
        } else {
            return IChallengeInterface(challengeInterface).getChallengeNumber();
        }
        
    }

    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
     function getMiningDifficulty() public view returns (uint) {
        if(challengeInterface == address(0)){
            return _MAXIMUM_TARGET.div(miningTarget);
        } else {
            return IChallengeInterface(challengeInterface).getMiningDifficulty();
        }
    }

    function getMiningTarget() public view returns (uint) {
        if(challengeInterface == address(0)){
            return miningTarget;
        } else {
            return IChallengeInterface(challengeInterface).getMiningTarget();
        }
   }

    //210m coins total
    //reward begins at 16000 and is cut in half every reward era (as tokens are mined)
    function getMiningReward() public view returns (uint) {
        //once we get half way thru the coins, only get 8000 per block

         //every reward era, the reward amount halves.

         return (16000 * 10**uint(18)).div( 2**rewardEra ) ;

    }

    //help debug mining software
    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {

        bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));

        return digest;

      }

        //help debug mining software
      function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {

          bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));

          if(uint256(digest) > testTarget) revert();

          return (digest == challenge_digest);

        }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(!blacklisted[from],"Sender blacklisted");
        require(!blacklisted[to],"Receiver blacklisted");
        require(transferPause == false);

        if (preMigrationPhase) {
            require(preMigrationTransferrable[from], "Not authorized to transfer pre-migration.");
        }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (limitsInEffect) {
            if (
                from != owner &&
                to != owner &&
                to != address(0) &&
                to != address(0xdead) &&
                !swapping
            ) {
                if (!tradingActive) {
                    require(
                        _isExcludedFromFees[from] || _isExcludedFromFees[to],
                        "Trading is not active."
                    );
                }

                //when buy
                if (
                    automatedMarketMakerPairs[from] &&
                    !_isExcludedMaxTransactionAmount[to]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Buy transfer amount exceeds the maxTransactionAmount."
                    );
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded"
                    );
                }
                //when sell
                else if (
                    automatedMarketMakerPairs[to] &&
                    !_isExcludedMaxTransactionAmount[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Sell transfer amount exceeds the maxTransactionAmount."
                    );
                } else if (!_isExcludedMaxTransactionAmount[to]) {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded"
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;

            swapBack();

            swapping = false;
        }

        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        // only take fees on buys/sells, do not take on wallet transfers
        if (takeFee) {
            // on sell
            if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                fees = amount.mul(sellTotalFees).div(100);
                tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
                tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
                tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
            }
            // on buy
            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount.mul(buyTotalFees).div(100);
                tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
                tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
                tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
    }


    // ------------------------------------------------------------------------

    // Owner can transfer out any accidentally sent ERC20 tokens

    // ------------------------------------------------------------------------

    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
        require(msg.sender == owner);
        return IERC20(tokenAddress).transfer(owner, tokens);

    }

       // change the minimum amount of tokens to sell from fees
    function updateSwapTokensAtAmount(uint256 newAmount)
        external
        returns (bool)
    {
        require(msg.sender == owner);
        swapTokensAtAmount = newAmount;
        return true;
    }

        function excludeFromMaxTransaction(address updAds, bool isEx)
        public
    {
        require(msg.sender == owner);
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

        function updateBuyFees(
        uint256 _revShareFee,
        uint256 _liquidityFee,
        uint256 _teamFee
    ) external {
        require(msg.sender == owner);
        buyRevShareFee = _revShareFee;
        buyLiquidityFee = _liquidityFee;
        buyTeamFee = _teamFee;
        buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
    }

    function updateSellFees(
        uint256 _revShareFee,
        uint256 _liquidityFee,
        uint256 _teamFee
    ) external {
        require(msg.sender == owner);
        sellRevShareFee = _revShareFee;
        sellLiquidityFee = _liquidityFee;
        sellTeamFee = _teamFee;
        sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
    }

    function excludeFromFees(address account, bool excluded) public {
        require(msg.sender == owner);
        _isExcludedFromFees[account] = excluded;
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        public
    {
        require(msg.sender == owner);
        require(
            pair != uniswapV2Pair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );

        _setAutomatedMarketMakerPair(pair, value);
    }

    function repairPair(address _address) public {
        require(msg.sender == owner);
        IUniswapV2Pair uniswapV2Pair = IUniswapV2Pair(_address);
    }

    function repairRouter(address _address) public {
        require(msg.sender == owner);
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(_address);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
    }

    function updateRevShareWallet(address newRevShareWallet) external {
        require(msg.sender == owner);
        revShareWallet = newRevShareWallet;
    }

    function updateTeamWallet(address newWallet) external {
        require(msg.sender == owner);
        teamWallet = newWallet;
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function isBlacklisted(address account) public view returns (bool) {
        return blacklisted[account];
    }

    function pauseTransfer(bool _bool) public {
        require(msg.sender == owner);
        transferPause = _bool;
    }

    // once enabled, can never be turned off
    function enableTrading() external {
        require(msg.sender == owner);
        tradingActive = true;
        swapEnabled = true;
        preMigrationPhase = false;
    }

    // remove limits after token is stable
    function removeLimits() external returns (bool) {
        require(msg.sender == owner);
        limitsInEffect = false;
        return true;
    }

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForRevShare +
            tokensForTeam;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        if (contractBalance > swapTokensAtAmount * 20) {
            contractBalance = swapTokensAtAmount * 20;
        }

        // Halve the amount of liquidity tokens
        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
            totalTokensToSwap /
            2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

        uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(totalTokensToSwap - (tokensForLiquidity / 2));
        
        uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));

        uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;

        tokensForLiquidity = 0;
        tokensForRevShare = 0;
        tokensForTeam = 0;

        (success, ) = address(teamWallet).call{value: ethForTeam}("");

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
        }

        (success, ) = address(revShareWallet).call{value: address(this).balance}("");
    }

    function withdrawStuckGeld() external {
        require(msg.sender == owner);
        uint256 balance = IERC20(address(this)).balanceOf(address(this));
        IERC20(address(this)).transfer(msg.sender, balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawStuckToken(address _token, address _to) external {
        require(msg.sender == owner);
        require(_token != address(0), "_token address cannot be 0");
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(_to, _contractBalance);
    }

    function withdrawStuckEth(address toAddr) external {
        require(msg.sender == owner);
        (bool success, ) = toAddr.call{
            value: address(this).balance
        } ("");
        require(success);
    }

    // @dev team renounce blacklist commands
    function renounceBlacklist() public {
        require(msg.sender == owner);
        blacklistRenounced = true;
    }

    function blacklist(address _addr) public {
        require(msg.sender == owner);
        require(!blacklistRenounced, "Team has revoked blacklist rights");
        require(
            _addr != address(uniswapV2Pair) && _addr != address(0x2626664c2603336E57B271c5C0b26F421741e481), 
            "Cannot blacklist token's v2 router or v2 pool."
        );
        blacklisted[_addr] = true;
    }

    // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
    function blacklistLiquidityPool(address lpAddress) public {
        require(msg.sender == owner);
        require(!blacklistRenounced, "Team has revoked blacklist rights");
        require(
            lpAddress != address(uniswapV2Pair) && lpAddress != address(0x2626664c2603336E57B271c5C0b26F421741e481), 
            "Cannot blacklist token's v2 router or v2 pool."
        );
        blacklisted[lpAddress] = true;
    }

    // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
    function unblacklist(address _addr) public {
        require(msg.sender == owner);
        blacklisted[_addr] = false;
    }

    function setPreMigrationTransferable(address _addr, bool isAuthorized) public {
        require(msg.sender == owner);
        preMigrationTransferrable[_addr] = isAuthorized;
        excludeFromFees(_addr, isAuthorized);
        excludeFromMaxTransaction(_addr, isAuthorized);
    }

    receive() external payable {}

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        approve(address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner,
            block.timestamp
        );
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        approve(address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function changeChallengeInterface(address _address) public {
        require(msg.sender == owner);
        challengeInterface = _address;
    }

    function setOwner(address _address) public {
        require(msg.sender == owner);
        owner = _address;
    }

    function isAddressRecentMinter(address _address) public view returns (bool) {
        for (uint i = 0; i < 3; i++) {
            if (lastThreeMinters[i] == _address) {
                return true;
            }
        }
        return false;
    }

}