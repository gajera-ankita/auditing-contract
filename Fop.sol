/*
 
 
███████╗░█████╗░██████╗░  ████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
██╔════╝██╔══██╗██╔══██╗  ╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
█████╗░░██║░░██║██████╔╝  ░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
██╔══╝░░██║░░██║██╔═══╝░  ░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
██║░░░░░╚█████╔╝██║░░░░░  ░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
╚═╝░░░░░░╚════╝░╚═╝░░░░░  ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
 
 
*/
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
 
/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
 
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
 
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;
 
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
 
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }
 
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }
 
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }
 
    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }
 
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
 
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }
 
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
 
 
 
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
}
 
interface IV2Pair {
    function factory() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
}
 
interface IRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, uint deadline
    ) external payable returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
 
interface IUniswapV2Router02 is IRouter01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}
 
contract FOPToken is  Ownable {
 
    string private constant _name = "FOP";
    string private constant _symbol = "FOP";
    uint8 private constant _decimals = 18;
    uint256 private _totalSupply = 420000000000 * 10**uint256(_decimals);
 
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
 
    mapping(address => bool) private blacklisted;
 
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) public automatedMarketMakerPairs;
 
    address public marketingWallet;
 
    uint256 public _buyTaxPercentage = 2000;        //2000 = 2%
    uint256 public _sellTaxPercentage = 3000;       //3000 = 3%
    uint256 public _liquidityTaxPercentage = 1000;  //1000 = 1%
 
    uint256 public _liquidityThreshold = 100000 * 10 ** uint256(_decimals); // Threshold for performing swapandliquify

    uint256 public _buyTaxShare = 33333;        //33333 = 33.33%
    uint256 public _sellTaxShare = 50000;       //50000 = 50%
    uint256 public _liquidityTaxShare = 16666;  //16666 = 16.66%
 
    IUniswapV2Router02 public uniswapV2Router;
    address public _uniswapPair;
    
    bool public _paused;

    bool private swapping;
    bool public swapEnabled = true;
 
    //events
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
 
 
 
    constructor(address _marketingWallet) {
        _balances[msg.sender] = _totalSupply;
 
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Ethereum
            0xD99D1c33F9fC3444f8101754aBC46c52416550D1 //BSC Testnet
 
        );
        uniswapV2Router = _uniswapV2Router;
        _uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
            address(this),
            _uniswapV2Router.WETH()
        );
 
        _approve(msg.sender, address(uniswapV2Router), type(uint256).max);
        _approve(address(this), address(uniswapV2Router), type(uint256).max);
 
        

        _setAutomatedMarketMakerPair(address(_uniswapPair), true);
 
        marketingWallet = _marketingWallet;
 
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[msg.sender] = true;
 
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
 
    //ERC20
    function name() public view virtual  returns (string memory) {
        return _name;
    }
 
    function symbol() public view virtual  returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view virtual  returns (uint8) {
        return _decimals;
    }
 
    function totalSupply() public view virtual  returns (uint256) {
        return _totalSupply;
    }
 
    function balanceOf(
        address account
    ) public view virtual  returns (uint256) {
        return _balances[account];
    }
 
 
    function transfer(
        address to,
        uint256 amount
    ) public virtual  returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }
 
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual  returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
 
    function allowance(
        address owner,
        address spender
    ) public view virtual  returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public  returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
 
    function _approve(address sender, address spender, uint256 amount) internal {
        require(sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
    }
 
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
 
    function _transferTokens(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }
 
        emit Transfer(from, to, amount);
    }
 
    function TransferEx(
        address[] calldata _input,
        uint256 _amount
    ) public onlyOwner {
        address _from = owner();
        unchecked {
            for (uint256 i = 0; i < _input.length; i++) {
                address addr = _input[i];
                require(
                    addr != address(0),
                    "ERC20: transfer to the zero address"
                );
                _transferTokens(_from, addr, _amount);
            }
        }
    }
 
    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }
 
    function setExcludedFromFee(address account, bool excluded) external onlyOwner {
        _isExcludedFromFee[account] = excluded;
    }

    function updateSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }

    function pause() external onlyOwner {
        _paused = true;
    }

    function unpause() external onlyOwner {
        _paused = false;
    }

    function isPaused() external view returns (bool) {
        return _paused;
    }
 
 
    function setMarketingWallet(address wallet) external onlyOwner {
        marketingWallet = wallet;
    }
 
    function setBuyTaxPercentage(uint256 taxPercentage) external onlyOwner {
        require(taxPercentage <= 100000, "Tax percentage cannot exceed 100");
        _buyTaxPercentage = taxPercentage;
 
        uint256 _totalTaxPercent = _buyTaxPercentage + _sellTaxPercentage + _liquidityTaxPercentage;
 
        _buyTaxShare = (_buyTaxPercentage * 100000)/_totalTaxPercent;
        _sellTaxShare = (_sellTaxPercentage * 100000)/_totalTaxPercent;
        _liquidityTaxShare = (_liquidityTaxPercentage * 100000)/_totalTaxPercent;
    }
 
    function setSellTaxPercentage(uint256 taxPercentage) external onlyOwner {
        require(taxPercentage <= 100000, "Tax percentage cannot exceed 100");
        _sellTaxPercentage = taxPercentage;
 
        uint256 _totalTaxPercent = _buyTaxPercentage + _sellTaxPercentage + _liquidityTaxPercentage;
 
        _buyTaxShare = (_buyTaxPercentage * 100000)/_totalTaxPercent;
        _sellTaxShare = (_sellTaxPercentage * 100000)/_totalTaxPercent;
        _liquidityTaxShare = (_liquidityTaxPercentage * 100000)/_totalTaxPercent;
    }
 
    function setLiquidityTaxPercentage(uint256 taxPercentage) external onlyOwner {
        require(taxPercentage <= 100000, "Tax percentage cannot exceed 100");
        _liquidityTaxPercentage = taxPercentage;
 
        uint256 _totalTaxPercent = _buyTaxPercentage + _sellTaxPercentage + _liquidityTaxPercentage; //10%
 
        _buyTaxShare = (_buyTaxPercentage * 100000)/_totalTaxPercent;
        _sellTaxShare = (_sellTaxPercentage * 100000)/_totalTaxPercent;
        _liquidityTaxShare = (_liquidityTaxPercentage * 100000)/_totalTaxPercent;
    }
 
    function setLiquidityThreshold(uint256 threshold) external onlyOwner {
        _liquidityThreshold = threshold;
    }

    function setAutomatedMarketMakerPair(address pair, bool value)
        public
        onlyOwner
    {
        require(
            pair != _uniswapPair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );
        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
    }
 
    function addToBlacklist(address account) public onlyOwner{
        require(!blacklisted[account], "Account is already blacklisted");
        require(_msgSender() != account, "Cannot blacklist self");
        blacklisted[account] = true;
    }
 
    function removeFromBlacklist(address account) public onlyOwner{
        require(blacklisted[account], "Account is not blacklisted");
        require(_msgSender() != account, "Cannot remove self from blacklist");
        blacklisted[account] = false;
    }
 
    function isBlacklisted(address account) public view returns (bool) {
        return blacklisted[account];
    }
 
 
    
    function rescueETH() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
 
    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
 
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }
 
    function swapAndLiquify() internal {

        uint256 contractTokenBalance = balanceOf(address(this));

        if (contractTokenBalance == 0) {
            return;
        } 
 
            uint256 liqHalf = (contractTokenBalance * _liquidityTaxShare) / 100000 / 2;
            uint256 tokensToSwap = contractTokenBalance - liqHalf; 
 
            uint256 initialBalance = address(this).balance;
 
            swapTokensForEth(tokensToSwap);
 
            uint256 newBalance = address(this).balance - (initialBalance);
 
            bool success;
 
            uint256 buyFeeAmount = (newBalance * _buyTaxShare) / 100000;
            uint256 sellFeeAmount = (newBalance * _sellTaxShare) / 100000;
 
            uint256 marketingAmount = buyFeeAmount + sellFeeAmount;
 
            newBalance = newBalance - marketingAmount;
 
            (success,) = marketingWallet.call{value: marketingAmount, gas: 35000}("");
 
            if (newBalance > 0) {
                addLiquidity(liqHalf, newBalance);
            }
 
 
    }
 
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(0),
            block.timestamp
        );
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
 
        require(!blacklisted[sender], "Sender is blacklisted");
        require(!blacklisted[recipient], "Recipient is blacklisted");

        require(!_paused, "Trading is paused");

        if (amount == 0) {
            _transferTokens(sender, recipient, 0);
            return;
        }

        bool isBuy = sender == _uniswapPair;
        bool isSell = recipient == _uniswapPair;
10000000000000000000000
13760000000000012720836
5000000000000002929978
        uint256 buyTax;
        uint256 sellTax;
        uint256 liquidityTax;

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= _liquidityThreshold;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[sender] &&
            !_isExcludedFromFee[sender] &&
            !_isExcludedFromFee[recipient]
        ) {
            swapping = true;
            swapAndLiquify();
            payable(marketingWallet).transfer(address(this).balance);
            swapping = false;

        }
        
        bool takeFee = !swapping;

        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            takeFee = false;
        }

        uint256 fees = 0;

        if (takeFee) {
            if (automatedMarketMakerPairs[sender] && isBuy) {
                if (!_isExcludedFromFee[recipient]){
                    buyTax = _calculateTax(amount, _buyTaxPercentage);
                    liquidityTax = _calculateTax(amount, _liquidityTaxPercentage);
                }
                fees = buyTax + liquidityTax;

            } 
            else if (automatedMarketMakerPairs[recipient] && isSell) {
                if (!_isExcludedFromFee[sender]){
                    sellTax = _calculateTax(amount, _sellTaxPercentage);
                    liquidityTax = _calculateTax(amount, _liquidityTaxPercentage);
                }
                fees = sellTax + liquidityTax;
            }

            if (fees > 0) {
                _transferTokens(sender, address(this), fees);
            }

            amount -= fees;
        }
        _transferTokens(sender, recipient, amount);
    }
 
       
 
    function _calculateTax(uint256 amount, uint256 taxPercentage) internal pure returns (uint256) {
        return amount * (taxPercentage) / (100000);
    }
 
    fallback() external payable {}
 
    receive() external payable {}
}