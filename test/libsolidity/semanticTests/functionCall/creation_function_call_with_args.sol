contract C {
    uint public i;
    constructor(uint newI) {
        i = newI;
    }
}
contract D {
    C c;
    constructor(uint v) {
        c = new C(v);
    }
    function f() public returns (uint r) {
        return c.i();
    }
}
// ====
// compileViaYul: also
// ----
// constructor(): 2 ->
// gas ir: 399719
// gas legacy: 282852
// gas legacyOptimized: 240295
// gas irOptimized: 214602
// f() -> 2
