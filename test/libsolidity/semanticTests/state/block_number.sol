contract C {
    constructor() {}
    function f() public returns (uint) {
        return block.number;
    }
}
// ====
// compileViaYul: also
// ----
// constructor()
// gas legacy: 100521
// gas ir: 130626
// f() -> 2
// f() -> 3
