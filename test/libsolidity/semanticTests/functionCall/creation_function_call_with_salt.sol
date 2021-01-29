contract C {
    uint public i;
    constructor(uint newI) {
        i = newI;
    }
}
contract D {
    C c;
    constructor(uint v) {
        c = new C{salt: "abc"}(v);
    }
    function f() public returns (uint r) {
        return c.i();
    }
}
// ====
// EVMVersion: >=constantinople
// compileViaYul: also
// ----
// constructor(): 2 ->
// gas ir: 400381
// gas legacy: 283242
// gas legacyOptimized: 240551
// gas irOptimized: 214833
// f() -> 2
