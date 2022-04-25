// SPDX-License-Identifier: MIT

pragma solidity =0.8.10;

interface IUniV3OracleAdapter {
    function getTwap(
        address _pool,
        address _base,
        address _quote,
        uint32 _period,
        bool _checkPeriod
    ) external view returns (uint256);
}