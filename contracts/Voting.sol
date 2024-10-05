// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        string party; 
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;

    uint public countCandidates;
    uint256 public votingEnd;
    uint256 public votingStart;

    event CandidateAdded(uint id, string name, string party);
    event Voted(address voter, uint candidateID);

    modifier onlyDuringVoting() {
        require(block.timestamp >= votingStart && block.timestamp < votingEnd, "Voting is not active.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    modifier validCandidate(uint candidateID) {
        require(candidateID > 0 && candidateID <= countCandidates, "Invalid candidate ID.");
        _;
    }

    function addCandidate(string memory name, string memory party) public returns (uint) {
        countCandidates++;
        candidates[countCandidates] = Candidate(countCandidates, name, party, 0);
        
        emit CandidateAdded(countCandidates, name, party);
        
        return countCandidates;
    }
   
    function vote(uint candidateID) 
        public 
        onlyDuringVoting 
        validCandidate(candidateID) 
        hasNotVoted 
    {
        voters[msg.sender] = true;
        candidates[candidateID].voteCount++;

        emit Voted(msg.sender, candidateID);
    }
    
    function checkVote() public view returns (bool) {
        return voters[msg.sender];
    }
       
    function getCountCandidates() public view returns (uint) {
        return countCandidates;
    }

    function getCandidate(uint candidateID) 
        public 
        view 
        validCandidate(candidateID) 
        returns (uint, string memory, string memory, uint) 
    {
        Candidate memory candidate = candidates[candidateID];
        return (candidate.id, candidate.name, candidate.party, candidate.voteCount);
    }

    function setDates(uint256 _startDate, uint256 _endDate) public {
        require(votingStart == 0 && votingEnd == 0, "Voting dates have already been set.");
        require(_startDate > block.timestamp, "Start date must be in the future.");
        require(_endDate > _startDate, "End date must be after start date.");

        votingStart = _startDate;
        votingEnd = _endDate;
    }

    function getDates() public view returns (uint256, uint256) {
      return (votingStart, votingEnd);
    }
}