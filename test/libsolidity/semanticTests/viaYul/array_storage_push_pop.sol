contract C {
    uint[] storageArray;
    function set_get_length(uint256 len) public returns (uint256) {
        while(storageArray.length < len)
            storageArray.push();
        while(storageArray.length > 0)
            storageArray.pop();
        return storageArray.length;
    }
}
// ====
// compileViaYul: also
// ----
// set_get_length(uint256): 0 -> 0
// set_get_length(uint256): 1 -> 0
// set_get_length(uint256): 10 -> 0
// gas ir: 121925
// set_get_length(uint256): 20 -> 0
// gas ir: 218885
// gas legacy: 141922
// gas legacyOptimized: 139741
// gas irOptimized: 162779
// set_get_length(uint256): 0xFF -> 0
// gas ir: 2497445
// gas legacy: 1524427
// gas legacyOptimized: 1500391
// gas irOptimized: 1792504
// set_get_length(uint256): 0xFFF -> 0
// gas ir: 39730097
// gas legacy: 24115159
// gas legacyOptimized: 23734003
// gas irOptimized: 28422916
// set_get_length(uint256): 0xFFFF -> FAILURE # Out-of-gas #
// gas ir: 100000000
// gas legacy: 100000000
// gas legacyOptimized: 100000000
// gas irOptimized: 100000000
