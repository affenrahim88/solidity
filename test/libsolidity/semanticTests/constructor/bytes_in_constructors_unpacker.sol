contract Test {
    uint public m_x;
    bytes public m_s;
    constructor(uint x, bytes memory s) {
        m_x = x;
        m_s = s;
    }
}
// ====
// compileViaYul: also
// ----
// constructor(): 7, 0x40, 78, "abcdefghijklmnopqrstuvwxyzabcdef", "ghijklmnopqrstuvwxyzabcdefghijkl", "mnopqrstuvwxyz" ->
// gas ir: 412296
// gas legacy: 319240
// gas legacyOptimized: 273132
// gas irOptimized: 311184
// m_x() -> 7
// m_s() -> 0x20, 78, "abcdefghijklmnopqrstuvwxyzabcdef", "ghijklmnopqrstuvwxyzabcdefghijkl", "mnopqrstuvwxyz"
