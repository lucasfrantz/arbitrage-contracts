// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
  function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
}

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function swap(uint256 amount0Out,	uint256 amount1Out,	address to,	bytes calldata data) external;
}

contract ArbitrageScanner is Ownable {
  function getAmountOutMin(address router, address _tokenIn, address _tokenOut, uint256 _amount) public view returns (uint256) {
		address[] memory path;
		path = new address[](2);
		path[0] = _tokenIn;
		path[1] = _tokenOut;
		uint256[] memory amountOutMins = IUniswapV2Router(router).getAmountsOut(_amount, path);
		return amountOutMins[path.length -1];
	}

  function estimateTradeBetweenTwoDexes(address _router1, address _router2, address _token1, address _token2, uint256 _amount) external view returns (uint256) {
    uint256 amountBack1 = getAmountOutMin(_router1, _token1, _token2, _amount);
    uint256 amountBack2 = getAmountOutMin(_router2, _token2, _token1, amountBack1);
    return amountBack2;
  }

  function estimateTradeBetweenThreeDexes(address _router1, address _router2, address _router3, address _token1, address _token2, address _token3, uint256 _amount) external view returns (uint256) {
		uint amountBack1 = getAmountOutMin(_router1, _token1, _token2, _amount);
		uint amountBack2 = getAmountOutMin(_router2, _token2, _token3, amountBack1);
		uint amountBack3 = getAmountOutMin(_router3, _token3, _token1, amountBack2);
		return amountBack3;
	}


}
