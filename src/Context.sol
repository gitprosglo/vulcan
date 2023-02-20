// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "./Vulcan.sol";
import "./Accounts.sol";

type Context is bytes32;

interface IMutator {
    function mutate() external pure;
}

/// @dev Contract used to check if a call is static or not.
contract CallContext {
    uint256 private val = 0;

    /// @dev Function used to check if the call can mutate the storage.
    function mutate() external {
        val = 0;
    }

    /// @dev Function to check if the current call is static.
    function isStaticcall() external view returns (bool) {
        try IMutator(address(this)).mutate() {
            return true;
        } catch {
            return false;
        }
    }
}

library ctx {
    /// @dev Deterministic address that will hold the code of the `CallContext` contract.
    address private constant CALL_CONTEXT_ADDRESS = address(uint160(uint256(keccak256("vulcan.ctx.callContext"))));

    /// @dev Function to initialize and set the code of `CALL_CONTEXT_ADDRESS`.
    function init() internal {
        accounts.setCode(CALL_CONTEXT_ADDRESS, type(CallContext).runtimeCode);
    }

    /// @dev Checks whether the current call is a static call or not.
    /// @return True if the current call is a static call, false otherwise.
    function isStaticcall() internal view returns (bool) {
        return CallContext(CALL_CONTEXT_ADDRESS).isStaticcall();
    }

    /// @dev sets the `block.timestamp` to `ts`
    /// @param ts the new block timestamp
    function setBlockTimestamp(Context self, uint256 ts) internal returns (Context) {
        vulcan.hevm.warp(ts);
        return self;
    }

    /// @dev sets the `block.timestamp` to `ts`
    /// @param ts the new block timestamp
    function setBlockTimestamp(uint256 ts) internal returns (Context) {
        return setBlockTimestamp(Context.wrap(0), ts);
    }

    /// @dev sets the `block.number` to `blockNumber`
    /// @param blockNumber the new block number
    function setBlockNumber(Context self, uint256 blockNumber) internal returns (Context) {
        vulcan.hevm.roll(blockNumber);
        return self;
    }

    /// @dev sets the `block.number` to `blockNumber`
    /// @param blockNumber the new block number
    function setBlockNumber(uint256 blockNumber) internal returns (Context) {
        return setBlockNumber(Context.wrap(0), blockNumber);
    }

    /// @dev sets the `block.basefee` to `baseFee`
    /// @param baseFee the new block base fee
    function setBlockBaseFee(Context self, uint256 baseFee) internal returns (Context) {
        vulcan.hevm.fee(baseFee);
        return self;
    }

    /// @dev sets the `block.basefee` to `baseFee`
    /// @param baseFee the new block base fee
    function setBlockBaseFee(uint256 baseFee) internal returns (Context) {
        return setBlockBaseFee(Context.wrap(0), baseFee);
    }

    /// @dev sets the `block.difficulty` to `difficulty`
    /// @param difficulty the new block difficulty
    function setBlockDifficulty(Context self, uint256 difficulty) internal returns (Context) {
        vulcan.hevm.difficulty(difficulty);
        return self;
    }

    /// @dev sets the `block.difficulty` to `difficulty`
    /// @param difficulty the new block difficulty
    function setBlockDifficulty(uint256 difficulty) internal returns (Context) {
        return setBlockDifficulty(Context.wrap(0), difficulty);
    }

    /// @dev sets the `block.chainid` to `chainId`
    /// @param chainId the new block chain id
    function setChainId(Context self, uint256 chainId) internal returns (Context) {
        vulcan.hevm.chainId(chainId);
        return self;
    }

    /// @dev sets the `block.chainid` to `chainId`
    /// @param chainId the new block chain id
    function setChainId(uint256 chainId) internal returns (Context) {
        return setChainId(Context.wrap(0), chainId);
    }

    /// @dev Sets the block coinbase to `who`.
    /// @param self The context.
    /// @param who The address to set as the block coinbase.
    /// @return The same context in order to allow function chaining.
    function setBlockCoinbase(Context self, address who) internal returns (Context) {
        vulcan.hevm.coinbase(who);
        return self;
    }

    /// @dev Sets the block coinbase to `who`.
    /// @param who The address to set as the block coinbase.
    /// @return The same context to allow function chaining.
    function setBlockCoinbase(address who) internal returns (Context) {
        return setBlockCoinbase(Context.wrap(0), who);
    }

    /// @dev Function used to check whether the next call reverts or not.
    /// @param revertData The function call data that that is expected to fail.
    function expectRevert(bytes memory revertData) internal {
        vulcan.hevm.expectRevert(revertData);
    }

    /// @dev Function used to check whether the next call reverts or not.
    /// @param revertData The function call signature that that is expected to fail.
    function expectRevert(bytes4 revertData) internal {
        vulcan.hevm.expectRevert(revertData);
    }

    /// @dev Function used to check whether the next call reverts or not.
    function expectRevert() external {
        vulcan.hevm.expectRevert();
    }

    /// @dev Checks if an event was emitted with the given properties.
    /// @param checkTopic1 Whether to check the first topic match.
    /// @param checkTopic2 Whether to check the second topic match.
    /// @param checkTopic3 Whether to check the third topic match.
    /// @param checkData Whether to check the data field match.
    function expectEmit(bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData) internal {
        vulcan.hevm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData);
    }

    /// @dev Checks if an event was emitted with the given properties.
    /// @param checkTopic1 Whether to check the first topic match.
    /// @param checkTopic2 Whether to check the second topic match.
    /// @param checkTopic3 Whether to check the third topic match.
    /// @param checkData Whether to check the data field match.
    /// @param emitter The address of the expected emitter.
    function expectEmit(bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData, address emitter)
        internal
    {
        vulcan.hevm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData, emitter);
    }

    /// @dev Function to mock a call to a specified address.
    /// @param callee The address that should be called.
    /// @param data The data that should be sent in the call.
    /// @param returnData The data that should be returned if `data` matches the sent data in the call.
    function mockCall(address callee, bytes memory data, bytes memory returnData) internal {
        vulcan.hevm.mockCall(callee, data, returnData);
    }

    /// @dev Function to mock a call to a specified address.
    /// @param callee The address that should be called.
    /// @param msgValue The `msg.value` that should be sent in the call.
    /// @param data The data that should be sent in the call.
    /// @param returnData The data that should be returned if `data` matches the sent data in the call.
    function mockCall(address callee, uint256 msgValue, bytes memory data, bytes memory returnData) internal {
        vulcan.hevm.mockCall(callee, msgValue, data, returnData);
    }

    /// @dev Function to clear all the mocked calls.
    function clearMockedCalls() internal {
        vulcan.hevm.clearMockedCalls();
    }

    /// @dev Used to check if a call to `callee` with `data` was made.
    /// @param callee The address that should have been called.
    /// @param data The data that should have been sent.
    function expectCall(address callee, bytes memory data) internal {
        vulcan.hevm.expectCall(callee, data);
    }

    /// @dev Used to check if a call to `callee` with `data` and `msgValue` was made.
    /// @param callee The address that should have been called.
    /// @param msgValue The `msg.value` that should have been sent.
    /// @param data The data that should have been sent.
    function expectCall(address callee, uint256 msgValue, bytes memory data) internal {
        vulcan.hevm.expectCall(callee, msgValue, data);
    }

    /// @dev Takes a snapshot of the current state of the vm and returns an identifier.
    /// @return The snapshot identifier.
    function snapshot(Context) internal returns (uint256) {
        return vulcan.hevm.snapshot();
    }

    /// @dev Reverts the state of the vm to the snapshot with id `snapshotId`.
    /// @param snapshotId The id of the snapshot to revert to.
    /// @return true if the vm was reverted to the selected snapshot.
    function revertToSnapshot(Context, uint256 snapshotId) internal returns (bool) {
        return vulcan.hevm.revertTo(snapshotId);
    }
}

using ctx for Context global;
