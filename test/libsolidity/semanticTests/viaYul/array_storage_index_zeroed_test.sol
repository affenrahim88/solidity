contract C {
    uint[] storageArray;
    function test_zeroed_indicies(uint256 len) public
    {
        while(storageArray.length < len)
            storageArray.push();
        while(storageArray.length > len)
            storageArray.pop();

        for (uint i = 0; i < len; i++)
            storageArray[i] = i + 1;

        if (len > 3)
        {
            while(storageArray.length > 0)
                storageArray.pop();
            while(storageArray.length < 3)
                storageArray.push();

            for (uint i = 3; i < len; i++)
            {
                assembly {
                    mstore(0, storageArray.slot)
                    let pos := add(keccak256(0, 0x20), i)

                    if iszero(eq(sload(pos), 0)) {
                        revert(0, 0)
                    }
                }
            }

        }

        while(storageArray.length > 0)
            storageArray.pop();
        while(storageArray.length < len)
            storageArray.push();

        for (uint i = 0; i < len; i++)
        {
            require(storageArray[i] == 0);

            uint256 val = storageArray[i];
            uint256 check;

            assembly { check := iszero(val) }

            require(check == 1);
        }
    }
}
// ====
// compileViaYul: also
// ----
// test_zeroed_indicies(uint256): 1 ->
// test_zeroed_indicies(uint256): 5 ->
// gas ir: 243517
// gas legacy: 191267
// gas legacyOptimized: 188486
// gas irOptimized: 222625
// test_zeroed_indicies(uint256): 10 ->
// gas ir: 363409
// gas legacy: 276129
// gas legacyOptimized: 271024
// gas irOptimized: 327375
// test_zeroed_indicies(uint256): 15 ->
// gas ir: 460299
// gas legacy: 339254
// gas legacyOptimized: 331904
// gas irOptimized: 409400
// test_zeroed_indicies(uint256): 0xFF ->
// gas ir: 10516489
// gas legacy: 8477449
// gas legacyOptimized: 8343774
// gas irOptimized: 9686975
