contract A {
    function f() public {
        new B();
    }
}


contract B {
    function f() public {}
}


contract C {
    function f() public {
        new B();
    }
}

// ====
// compileToEwasm: also
// compileViaYul: also
// ----
// constructor() ->
// gas ir: 204030
// gas legacy: 133911
// gas legacyOptimized: 133923
// gas irOptimized: 124731
