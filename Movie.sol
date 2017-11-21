pragma solidity ^0.4.18;
import "./Rentable.sol";

contract Movie is Rentable {

    string public name;
    string public genre;
    uint public duration;
    uint public timesPlayed;

    function Movie(string _name, string _genre, uint _duration) public
    {
        name = _name;
        genre = _genre;
        duration = _duration;
        timesPlayed = 0;
    }

    function watchMovie() public onlyRenter whenRented returns(bool){
        timesPlayed++;
        return true;
    }
}
