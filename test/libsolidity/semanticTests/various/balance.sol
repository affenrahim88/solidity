contract test {
    constructor() payable {}

    function getBalance() public returns (uint256 balance) {
        return address(this).balance;
    }
}

// ====
// compileViaYul: also
// ----
// constructor(), 23 wei ->
// gas legacy: 100313
// gas ir: 144887
// getBalance() -> 23
