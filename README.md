# Rentable
A contract for making contracts that can be rented.

The Rentable contract allows any contract inheriting from it to be rented.
The owner of the object (whoever deployed the contract) can set the terms of the rental and make the object available for others to use it for as long as they want (within some limits set by the owner).

## How it works

Once the contract that implements the Rentable protocol is deployed, any account can rent the object by calling the rent() function and supplying the necessary amount of ether. The return date Depends on what the object's rental price is and how much ether the renter supplies. The calculated return time has to be greater than the minimum rental period and can't exceed the maximum rental period, both set by the owner. (This prevents an item to be rented for a few seconds or for tens of years).

The owner of the contract will need to do some basic setup, which includes:

- Setting the rental price: How much wei per second it costs to rent the object. 
- Minimum rental period: The minimum time (in seconds) the renter has to rent the object for. For example, if it was a parking space, the owner could set a minimum 1 hour period. If it was some office space, it could be a minimum of 6 months.
- Maximum rental period: The maximum time (in seconds) the renter can rent the object for. For example, if it was a parking space, the owner could set a maximum 24 hours period.

It's worth noting that the minimum rental period also establishes how much money will be refunded for an early return. For example: If I rent a movie which minimum rental period is 12 hours and I supply enough ether for a 24 hours rental (1 ether per hour), if I return it before the 24 hours have passed, I will be refunded for the hours I didn't use the object. If I renturn it after 20 hours, I will be refunded 4 ether of the 24 I initially paid. But if I return the object within the minimum rental period I will still have to pay those minimum 12 hours, getting a refund of just the other 12 hours only.

Once the item has been setup, any account can call the rent() function providing ether to it. The rental return date will be calculated based on the ether supplied and cost per second the owner previously set.

While someone is the current renter of the item, they can call the functions of the contract marked as onlyRenter. At any moment they can call returnRental() to end the rental and get a refund (if applicable) of the time remaining.

If they don't return the item, once the rental return date is reached, they will be unable to keep using the item and the owner can call forceRentalEnd() to remove the item from them and make it available for someone else.

## How to implement it

1. Create a contract that inherits from Rentable and import Rentable.sol

2. Decide which function(s) you want to make only callable by the person currently renting the object. (Notice that an object can only be rented by one person at the same time). 

3. On each of the functions that you want to restrict usage, add these 2 modifiers: onlyRenter and whenRented.

- onlyRenter will cause the function to require it to be executed by the address currently set as renter.
- whenRented will cause the function to fail if executed outside of the rental period set for the current renter.


## Rentable object setup

Before the object set as Rentable can be used, there's a few steps that have to be performed.

1. Deploy the contract inheriting from Rentable.

2. Make the object available. As default, the object won't be avalaible for rental. First, you have to define it's price per hour, minimum and maximum rental time by calling rentableSetup(uint _pricePerHour, uint _minRentalTime, uint _maxRentalTime).
Once you call this function, the object will be available for rental.

3. While the object is not rented, you can modify its rental price. There's 3 functions to do so: setRentalPricePerDay(), setRentalPricePerHour(), setRentalPricePerSecond(). Use the one that makes more sense to you depending the use case. All 3 of them do the same, they set how much wei per second the rental costs.


## How to interact with a Rentable contract

Once your Rentable object has been set up, any account can rent it.
