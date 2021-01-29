contract helper {
    function getBalance() public payable returns (uint256 myBalance) {
        return address(this).balance;
    }
}


contract test {
    helper h;

    constructor() payable {
        h = new helper();
    }

    function sendAmount(uint256 amount) public returns (uint256 bal) {
        return h.getBalance{value: amount + 3, gas: 1000}();
    }
}

// ====
// compileViaYul: also
// ----
// constructor(), 20 wei ->
// gas ir: 404870
// gas legacy: 305146
// gas legacyOptimized: 232321
// gas irOptimized: 205322
// sendAmount(uint256): 5 -> 8
