# Rentable
A contract for making contracts/items that can be rented.

The Rentable contract allows any contract inheriting from it to be rented.
The owner of the item (whoever deployed the contract) can set the terms of the rental and make the item available for others to use it for as long as they want (within some limits set by the owner).

## How it works

Once the contract that implements the Rentable protocol is deployed, any account can rent the item by calling the rent() function and supplying the necessary amount of ether. The return date depends on what the item's rental price is and how much ether the renter supplies. The calculated return time has to be greater than the minimum rental period and can't exceed the maximum rental period, both set by the owner. (This prevents an item to be rented for a few seconds or for tens of years).

The owner of the contract will need to do some basic setup, which includes:

- Setting the rental price: How much wei per second it costs to rent the item. 
- Minimum rental period: The minimum time (in seconds) the renter has to rent the item for. For example, if it was a parking space, the owner could set a minimum 1 hour period. If it was some office space, it could be a minimum of 6 months.
- Maximum rental period: The maximum time (in seconds) the renter can rent the item for. For example, if it was a parking space, the owner could set a maximum 24 hours period.

It's worth noting that the minimum rental period also establishes how much money will be refunded for an early return. For example: If I rent a movie which minimum rental period is 12 hours and I supply enough ether for a 24 hours rental (1 ether per hour), if I return it before the 24 hours have passed, I will be refunded for the hours I didn't use the item. If I renturn it after 20 hours, I will be refunded 4 ether of the 24 I initially paid. But if I return the item within the minimum rental period I will still have to pay those minimum 12 hours, getting a refund of just the other 12 hours only.

Once the item has been setup, any account can call the rent() function providing ether to it. The rental return date will be calculated based on the ether supplied and cost per second the owner previously set.

While someone is the current renter of the item, they can call the functions of the contract marked as onlyRenter. At any moment they can call returnRental() to end the rental and get a refund (if applicable) of the time remaining.

If they don't return the item, once the rental return date is reached, they will be unable to keep using the item and the owner can call forceRentalEnd() to remove the item from them and make it available for someone else.

## How to implement it

1. Create a contract that inherits from Rentable and import Rentable.sol

2. Decide which function(s) you want to make only callable by the person currently renting the item. (Notice that an item can only be rented by one person at the same time). 

3. On each of the functions that you want to restrict usage, add these 2 modifiers: onlyRenter and whenRented.

- onlyRenter will cause the function to require it to be executed by the address currently set as renter.
- whenRented will cause the function to fail if executed outside of the rental period set for the current renter.


## Rentable item setup

Before the item set as Rentable can be used, there's a few steps that have to be performed.

1. Deploy the contract inheriting from Rentable.

2. Make the item available. As default, the item won't be avalaible for rental. First, you have to define it's price per hour, minimum and maximum rental time by calling rentableSetup(uint _pricePerHour, uint _minRentalTime, uint _maxRentalTime).
Once you call this function, the item will be available for rental.

3. While the item is not rented, you can modify its rental price. There's 3 functions to do so: setRentalPricePerDay(), setRentalPricePerHour(), setRentalPricePerSecond(). Use the one that makes more sense to you depending the use case. All 3 of them do the same, they set how much wei per second the rental costs.


## How to interact with a Rentable contract

Once your Rentable item has been set up, any account can rent it by calling the rent() function or just by sending ether to the contract (and supplying enough gas). 

1. The account trying to rent the item executes the rent() function while supplying ether to it. If enough ether was supplied to rent the item within the minimum and maximum thresholds, then the item gets rented by the account.

2. While the account is the renter of the item, they can execute any function marked as onlyRenter and whenRented.

3. To return the item (and recover any unspent funds) the renter has to call returnRental().

## Examples

I've included a Movie.sol contract which implements the Rentable protocol.
Once deployed, anyone can rent the movie and call the watchMovie() function to "watch it".

