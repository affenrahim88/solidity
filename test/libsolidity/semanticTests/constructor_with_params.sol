contract C {
    uint public i;
    uint public k;

    constructor(uint newI, uint newK) {
        i = newI;
        k = newK;
    }
}
// ====
// compileViaYul: also
// ----
// constructor(): 2, 0 ->
// gas ir: 198085
// gas legacy: 133216
// gas legacyOptimized: 118894
// gas irOptimized: 137306
// i() -> 2
// k() -> 0
