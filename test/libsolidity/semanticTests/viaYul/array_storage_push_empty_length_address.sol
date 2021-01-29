contract C {
    address[] addressArray;
    function set_get_length(uint256 len) public returns (uint256)
    {
        while(addressArray.length < len)
            addressArray.push();
        while(addressArray.length > len)
            addressArray.pop();
        return addressArray.length;
    }
}
// ====
// EVMVersion: >=petersburg
// compileViaYul: also
// ----
// set_get_length(uint256): 0 -> 0
// set_get_length(uint256): 1 -> 1
// set_get_length(uint256): 10 -> 10
// set_get_length(uint256): 20 -> 20
// set_get_length(uint256): 0 -> 0
// gas ir: 144209
// gas legacy: 107830
// gas legacyOptimized: 107295
// gas irOptimized: 110296
// set_get_length(uint256): 0xFF -> 0xFF
// gas ir: 994431
// gas legacy: 882337
// gas legacyOptimized: 650737
// gas irOptimized: 702388
// set_get_length(uint256): 0xFFF -> 0xFFF
// gas ir: 14624613
// gas legacy: 12945874
// gas legacyOptimized: 9462679
// gas irOptimized: 10238500
// set_get_length(uint256): 0xFFFF -> FAILURE # Out-of-gas #
// gas ir: 100000000
// gas legacy: 100000000
// gas legacyOptimized: 100000000
// gas irOptimized: 100000000
