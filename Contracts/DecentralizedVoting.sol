
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DecentralizedVoting
 * @dev A simple decentralized voting system smart contract
 */
contract Project {
    
    // Struct to represent a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    
    // Struct to represent a voter
    struct Voter {
        bool hasVoted;
        uint256 votedCandidateId;
    }
    
    // State variables
    address public admin;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint256 public candidatesCount;
    bool public votingActive;
    
    // Events
    event CandidateAdded(uint256 indexed candidateId, string name);
    event VoteCasted(address indexed voter, uint256 indexed candidateId);
    event VotingStatusChanged(bool status);
    
    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier votingIsActive() {
        require(votingActive, "Voting is not active");
        _;
    }
    
    /**
     * @dev Constructor sets the contract deployer as admin
     */
    constructor() {
        admin = msg.sender;
        votingActive = false;
    }
    
    /**
     * @dev Add a new candidate to the voting system
     * @param _name Name of the candidate
     */
    function addCandidate(string memory _name) public onlyAdmin {
        require(bytes(_name).length > 0, "Candidate name cannot be empty");
        
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        
        emit CandidateAdded(candidatesCount, _name);
    }
    
    /**
     * @dev Cast a vote for a candidate
     * @param _candidateId ID of the candidate to vote for
     */
    function vote(uint256 _candidateId) public votingIsActive {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;
        
        candidates[_candidateId].voteCount++;
        
        emit VoteCasted(msg.sender, _candidateId);
    }
    
    /**
     * @dev Toggle voting status (start/stop voting)
     * @param _status True to activate voting, false to deactivate
     */
    function setVotingStatus(bool _status) public onlyAdmin {
        votingActive = _status;
        emit VotingStatusChanged(_status);
    }
    
    /**
     * @dev Get candidate details
     * @param _candidateId ID of the candidate
     * @return id Candidate ID
     * @return name Candidate name
     * @return voteCount Number of votes received
     */
    function getCandidate(uint256 _candidateId) public view returns (
        uint256 id,
        string memory name,
        uint256 voteCount
    ) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
    
    /**
     * @dev Get the winning candidate
     * @return winningCandidateId ID of the winning candidate
     * @return winningCandidateName Name of the winning candidate
     * @return winningVoteCount Vote count of the winning candidate
     */
    function getWinner() public view returns (
        uint256 winningCandidateId,
        string memory winningCandidateName,
        uint256 winningVoteCount
    ) {
        require(candidatesCount > 0, "No candidates available");
        
        uint256 maxVotes = 0;
        uint256 winnerId = 0;
        
        for (uint256 i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        
        return (winnerId, candidates[winnerId].name, candidates[winnerId].voteCount);
    }
}
/Decentralized Voting.
