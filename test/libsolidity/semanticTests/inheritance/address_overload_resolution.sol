contract C {
    function balance() public returns (uint256) {
        return 1;
    }

    function transfer(uint256 amount) public returns (uint256) {
        return amount;
    }
}


contract D {
    function f() public returns (uint256) {
        return (new C()).balance();
    }

    function g() public returns (uint256) {
        return (new C()).transfer(5);
    }
}

// ====
// compileViaYul: also
// ----
// f() -> 1
// gas ir: 172056
// gas legacy: 132636
// gas legacyOptimized: 100828
// gas irOptimized: 111246
// g() -> 5
// gas ir: 172294
// gas legacy: 133096
// gas legacyOptimized: 100953
// gas irOptimized: 111379
