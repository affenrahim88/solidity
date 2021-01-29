contract c {
    uint spacer1;
    uint spacer2;
    uint[20] data;
    function fill() public {
        for (uint i = 0; i < data.length; ++i) data[i] = i+1;
    }
    function clear() public { delete data; }
}
// ====
// compileToEwasm: also
// compileViaYul: also
// ----
// storage: empty
// fill() ->
// gas ir: 462405
// gas legacy: 429460
// gas legacyOptimized: 425520
// gas irOptimized: 423997
// storage: nonempty
// clear() ->
// storage: empty
