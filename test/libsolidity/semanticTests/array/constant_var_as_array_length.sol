contract C {
    uint256 constant LEN = 3;
    uint256[LEN] public a;

    constructor(uint256[LEN] memory _a) {
        a = _a;
    }
}

// ====
// compileViaYul: also
// ----
// constructor(): 1, 2, 3 ->
// gas ir: 273504
// gas legacy: 195060
// gas legacyOptimized: 167727
// gas irOptimized: 141035
// a(uint256): 0 -> 1
// a(uint256): 1 -> 2
// a(uint256): 2 -> 3
