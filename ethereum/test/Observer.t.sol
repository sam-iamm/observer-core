// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.10;

import "ds-test/test.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/Observer.sol";

contract ContractTest is DSTest {
    using stdStorage for StdStorage;

    Vm private vm = Vm(HEVM_ADDRESS);
    Observer private observer;
    StdStorage private stdstore;

    function setUp() public {
        address mainnetStarknetCoreAddress = 0xc662c410C0ECf747543f5bA90660f6ABeBD9C8c4;
        address goerliStarknetCoreAddress = 0xde29d060D45901Fb19ED6C6e959EB22d8626708e;
        address hackathonStarknetCoreAddress = 0x39347118500B2695b0e3966d3D83238a98037287;

        address mainnetUniV3OracleAdapterAddr = 0x65D66c76447ccB45dAf1e8044e918fA786A483A1;
        address goerliUniV3OracleAdapterAddr = 0x2ebbc71ef0551ae3b41854E8D86670552c244EC7;

        observer = new Observer(goerliStarknetCoreAddress, goerliUniV3OracleAdapterAddr);
    }

    function testAddOracle() public {
        address mainnetPool = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
        address mainnetBaseCurrency = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address mainnetQuoteCurrency = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

        address goerliPool = 0x6337B3caf9C5236c7f3D1694410776119eDaF9FA;
        address goerliBaseCurrency = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
        address goerliQuoteCurrency = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;

        uint starknetAddress = 141551989423097248866616998390962290157327007918182752429907411460623481972;
        uint starknetSelector = 1130546766199376955330221921804311501627411914627058929385114183185019582423;

        uint32 twapPeriod = 300;
        uint updateDeviationThreshold = 50;
        uint updateDurationThreshold = 3600;
        uint incentiveBaseFeeMultiplier = 12000;

        observer.addUniV3Oracle(
            goerliPool,
            goerliBaseCurrency,
            goerliQuoteCurrency,
            twapPeriod,
            updateDeviationThreshold,
            updateDurationThreshold,
            incentiveBaseFeeMultiplier,
            starknetAddress,
            starknetSelector
        );
    }
}
