contract Creator {
    uint256 public r;
    address public ch;

    constructor(address[3] memory s, uint256 x) {
        r = x;
        ch = s[2];
    }
}
// ====
// compileViaYul: also
// ----
// constructor(): 1, 2, 3, 4 ->
// gas ir: 262732
// gas legacy: 192626
// gas legacyOptimized: 151448
// gas irOptimized: 169280
// r() -> 4
// ch() -> 3
