contract A {
    uint x = 42;
    function f() public returns(uint256) {
        return x;
    }
}
contract B is A {
    uint public y = f();
}
// ====
// compileToEwasm: also
// compileViaYul: also
// ----
// constructor() ->
// gas ir: 232112
// gas legacy: 151224
// gas legacyOptimized: 137676
// gas irOptimized: 153851
// y() -> 42
