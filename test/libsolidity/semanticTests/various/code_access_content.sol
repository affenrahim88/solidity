contract D {
    bytes32 public x;

    constructor() {
        bytes32 codeHash;
        assembly {
            let size := codesize()
            codecopy(mload(0x40), 0, size)
            codeHash := keccak256(mload(0x40), size)
        }
        x = codeHash;
    }
}


contract C {
    function testRuntime() public returns (bool) {
        D d = new D();
        bytes32 runtimeHash = keccak256(type(D).runtimeCode);
        bytes32 otherHash;
        uint256 size;
        assembly {
            size := extcodesize(d)
            extcodecopy(d, mload(0x40), 0, size)
            otherHash := keccak256(mload(0x40), size)
        }
        require(size == type(D).runtimeCode.length);
        require(runtimeHash == otherHash);
        return true;
    }

    function testCreation() public returns (bool) {
        D d = new D();
        bytes32 creationHash = keccak256(type(D).creationCode);
        require(creationHash == d.x());
        return true;
    }
}
// ====
// compileViaYul: also
// ----
// testRuntime() -> true
// gas ir: 164297
// gas legacy: 119014
// gas legacyOptimized: 111042
// testCreation() -> true
// gas ir: 165984
// gas legacy: 120227
// gas legacyOptimized: 112024
