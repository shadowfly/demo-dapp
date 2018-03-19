pragma solidity ^0.4.0;
Safe Remote Purchase 担保购物合约

contract Purchase
{
    uint public value;
    address public seller;
    address public buyer;
    enum State { Created, Locked, Inactive }
    State public state;
    function Purchase()
    {
        seller = msg.sender;
        value = msg.value / 2;
        if (2 * value != msg.value) throw;
    }
    modifier require(bool _condition)
    {
        if (!_condition) throw;
        _
    }
    modifier onlyBuyer()
    {
        if (msg.sender != buyer) throw;
        _
    }
    modifier onlySeller()
    {
        if (msg.sender != seller) throw;
        _
    }
    modifier inState(State _state)
    {
        if (state != _state) throw;
        _
    }
    event aborted();
    event purchaseConfirmed();
    event itemReceived();

   ///终止购物并收回以太。仅仅可以在合约未锁定时被卖家调用。
    function abort()
        onlySeller
        inState(State.Created)
    {
        aborted();
        seller.send(this.balance);
        state = State.Inactive;
    }

   ///买家确认购买。交易包含两倍价值的（`2 * value`）以太。
   ///这些以太会一直锁定到收货确认(confirmReceived)被调用。
    function confirmPurchase()
        inState(State.Created)
        require(msg.value == 2 * value)
    {
        purchaseConfirmed();
        buyer = msg.sender;
        state = State.Locked;
    }

    ///确认你（买家）收到了货物，这将释放锁定的以太。
    function confirmReceived()
        onlyBuyer
        inState(State.Locked)
    {
        itemReceived();
        buyer.send(value);
        seller.send(this.balance);
        state = State.Inactive;
    }
    function() { throw; }
}
