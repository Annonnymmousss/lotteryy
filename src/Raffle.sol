// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.4.0/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
/**
 * @title A sample Raffle Contract
 * @author Patrick Collins (or even better, you own name)
 * @notice This contract is for creating a sample raffle
 * @dev It implements Chainlink VRFv2.5 and Chainlink Automation
 */

contract Raffle {
    /**
     * errors
     */

    error Raffle_sendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    address payable[] private s_players;

    /* events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee , uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval=interval;
        s_lastTimeStamp=block.timestamp;
    }

    function enterRaffle() external payable {
        // revert(msg.value<i_entranceFee , "Not enough eth").       but this cost more gas
        if (msg.value < i_entranceFee) {
            revert Raffle_sendMoreToEnterRaffle();
        }
        //in the latest version of solidity there is one more efficient method
        //revert (msg.value<i_entranceFee , Raffle_sendMoreToEnterRaffle()). this is the most cost efficient

        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }


    function pickWinner() external {
        if((block.timestamp-s_lastTimeStamp)<i_interval){
            revert();
        }
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
    }

    /**
     * Getter Functions
     */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}